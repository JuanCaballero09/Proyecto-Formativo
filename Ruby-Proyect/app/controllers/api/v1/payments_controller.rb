# app/controllers/api/v1/payments_controller.rb
module Api
  module V1
    class PaymentsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_order, only: [:create, :status]

      # POST /api/v1/orders/:order_code/payments
      def create
        unless validate_terms
          return render_error("Debes aceptar los términos y autorizar el tratamiento de datos.", :unprocessable_entity)
        end

        service = WompiService.new
        payment_method = payment_params[:payment_method] || "card"

        case payment_method
        when "card"
          process_card_payment(service)
        when "nequi"
          process_nequi_payment(service)
        when "cash"
          process_cash_payment
        else
          render_error("Método de pago no válido", :unprocessable_entity)
        end
      end

      # GET /api/v1/orders/:order_code/payments/status
      def status
        payment = @order.payments.last

        if payment.nil?
          render json: {
            status: "pending",
            order_code: @order.code,
            order_status: @order.status
          }
        else
          render json: {
            status: payment.status,
            payment_method: payment.payment_method,
            amount: payment.amount,
            transaction_id: payment.transaction_id,
            order_code: @order.code,
            order_status: @order.status,
            created_at: payment.created_at
          }
        end
      end

      # POST /api/v1/orders/:order_code/payments/cancel
      def cancel
        payment = @order.payments.last
        
        if payment.nil?
          return render_error("No se encontró un pago para esta orden", :not_found)
        end

        if payment.status == "pending"
          payment.update(status: "cancelled")
          render json: {
            status: "cancelled",
            message: "Pago cancelado exitosamente",
            order_code: @order.code
          }
        else
          render_error("No se puede cancelar un pago con estado: #{payment.status}", :unprocessable_entity)
        end
      end

      # POST /api/v1/webhooks/wompi
      def webhook
        event = params[:event]
        data = params[:data]

        Rails.logger.info "=== WEBHOOK RECIBIDO DE WOMPI ==="
        Rails.logger.info "Event: #{event}"
        Rails.logger.info "Data: #{data.inspect}"

        # Verificar la firma del webhook (opcional pero recomendado)
        unless verify_webhook_signature
          return render json: { error: "Invalid signature" }, status: :unauthorized
        end

        case event
        when "transaction.updated"
          handle_transaction_update(data)
        else
          Rails.logger.warn "Evento no manejado: #{event}"
        end

        render json: { status: "received" }, status: :ok
      end

      private

      def set_order
        @order = Order.find_by!(code: params[:order_code])
      rescue ActiveRecord::RecordNotFound
        render_error("Orden no encontrada", :not_found)
      end

      def payment_params
        params.require(:payment).permit(
          :payment_method, :type_card, :card_number, :exp_year,
          :exp_month, :cvc, :installments,
          :email, :card_holder, :accept_terms, :accept_data, :phone_number
        )
      end

      def validate_terms
        payment_params[:accept_terms] == "1" && payment_params[:accept_data] == "1"
      end

      def render_error(message, status = :bad_request)
        render json: { error: message }, status: status
      end

      def render_success(data, message = "Operación exitosa")
        render json: {
          success: true,
          message: message,
          data: data
        }, status: :ok
      end

      def process_card_payment(service)
        # Tokenizar tarjeta
        token_response = service.tokenize_card(
          card_number: payment_params[:card_number],
          exp_month: payment_params[:exp_month].to_s.rjust(2, "0"),
          exp_year: payment_params[:exp_year].to_s[-2..],
          cvv: payment_params[:cvc],
          card_holder: payment_params[:card_holder]
        )

        Rails.logger.info "=== RESPUESTA DE TOKENIZACIÓN ==="
        Rails.logger.info token_response.inspect

        unless token_response["data"] && token_response["data"]["id"]
          error_message = extract_error_message(token_response)
          return render_error(error_message, :unprocessable_entity)
        end

        token = token_response["data"]["id"]
        reference = "PAYMENT-#{@order.code}"
        amount_in_cents = (@order.calculate_total * 100).to_i

        type_card = payment_params[:type_card] || "credit"
        installments = type_card == "debit" ? 1 : (payment_params[:installments].presence || 1).to_i

        # Crear transacción con el token
        response = service.create_card_transaction(
          reference: reference,
          amount_in_cents: amount_in_cents,
          customer_email: payment_params[:email],
          token: token,
          installments: installments
        )

        Rails.logger.info "=== RESPUESTA DE WOMPI ==="
        Rails.logger.info response.inspect

        if response["data"]
          transaction_id = response["data"]["id"]

          payment = @order.payments.create!(
            payment_method: :card,
            type_card: type_card,
            amount: amount_in_cents / 100.0,
            transaction_id: transaction_id,
            token: token,
            installment: installments,
            status: :pending
          )

          render_success({
            payment_id: payment.id,
            transaction_id: transaction_id,
            status: payment.status,
            amount: payment.amount,
            order_code: @order.code
          }, "Pago con tarjeta procesado. Esperando confirmación.")
        else
          error_message = extract_error_message(response)
          render_error(error_message, :unprocessable_entity)
        end
      end

      def process_nequi_payment(service)
        reference = "PAYMENT-#{@order.code}"
        amount_in_cents = (@order.calculate_total * 100).to_i
        phone_number = payment_params[:phone_number]

        unless phone_number =~ /^\d{10}$/
          return render_error("El número de teléfono debe tener 10 dígitos", :unprocessable_entity)
        end

        response = service.create_nequi_transaction(
          reference: reference,
          amount_in_cents: amount_in_cents,
          customer_email: payment_params[:email],
          phone_number: phone_number
        )

        Rails.logger.info "=== RESPUESTA DE NEQUI ==="
        Rails.logger.info response.inspect

        if response["data"]
          transaction_id = response["data"]["id"]

          payment = @order.payments.create!(
            payment_method: :nequi,
            amount: amount_in_cents / 100.0,
            transaction_id: transaction_id,
            phone_number: phone_number,
            status: :pending
          )

          render_success({
            payment_id: payment.id,
            transaction_id: transaction_id,
            status: payment.status,
            amount: payment.amount,
            phone_number: phone_number,
            order_code: @order.code
          }, "Solicitud de pago enviada a Nequi. Revisa tu app para aprobar la transacción.")
        else
          error_message = extract_error_message(response)
          render_error(error_message, :unprocessable_entity)
        end
      end

      def process_cash_payment
        begin
          ActiveRecord::Base.transaction do
            payment = @order.payments.create!(
              payment_method: :cash,
              amount: @order.calculate_total,
              status: :pending
            )

            @order.update!(status: :pagado)

            render_success({
              payment_id: payment.id,
              status: payment.status,
              amount: payment.amount,
              payment_method: "cash",
              order_code: @order.code,
              order_status: @order.status
            }, "Pedido confirmado. Pagarás #{payment.amount} COP en efectivo al recibir tu orden.")
          end
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error "[API PaymentsController#process_cash_payment] Error: #{e.record.errors.full_messages.join(', ')}"
          render_error("No se pudo registrar el pago: #{e.record.errors.full_messages.join(', ')}", :unprocessable_entity)
        rescue => e
          Rails.logger.error "[API PaymentsController#process_cash_payment] ERROR: #{e.class} #{e.message}"
          render_error("Ocurrió un error al procesar el pago en efectivo.", :internal_server_error)
        end
      end

      def extract_error_message(response)
        if response["error"]
          if response["error"]["messages"]
            response["error"]["messages"].values.flatten.join(", ")
          else
            response["error"]["reason"] || response["error"]["message"] || "Error desconocido"
          end
        else
          "Error desconocido"
        end
      end

      def handle_transaction_update(data)
        transaction_id = data["id"]
        status = data["status"]

        payment = Payment.find_by(transaction_id: transaction_id)

        unless payment
          Rails.logger.warn "No se encontró el pago con transaction_id: #{transaction_id}"
          return
        end

        case status
        when "APPROVED"
          payment.update(status: :approved)
          Rails.logger.info "Pago aprobado: #{transaction_id}"
        when "DECLINED"
          payment.update(status: :declined)
          Rails.logger.info "Pago rechazado: #{transaction_id}"
        when "ERROR"
          payment.update(status: :declined)
          Rails.logger.info "Error en el pago: #{transaction_id}"
        when "VOIDED"
          payment.update(status: :cancelled)
          Rails.logger.info "Pago anulado: #{transaction_id}"
        else
          Rails.logger.info "Estado del pago: #{status} para #{transaction_id}"
        end
      end

      def verify_webhook_signature
        # Implementa la verificación de firma según la documentación de Wompi
        # Por ahora retorna true, pero deberías implementar la verificación real
        true
      end
    end
  end
end
