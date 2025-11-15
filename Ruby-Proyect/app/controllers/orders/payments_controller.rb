# app/controllers/orders/payments_controller.rb
class  Orders::PaymentsController < ApplicationController
  layout "application_min"
  skip_before_action :verify_authenticity_token, only: [ :create ]
  before_action :set_order

  def new
    case @order.status
    when "pagado"
      redirect_to root_path, alert: "Esta orden ya fue pagada."
    when "cancelado"
      redirect_to root_path, alert: "Esta orden fue cancelada."
    else
      @payment = @order.payments.new
    end
  end

  def cancel
    payment = @order.payments.last
    if payment && payment.status == "pending"
      payment.update(status: "cancelled")
    end

    redirect_to root_path, alert: "La orden ha sido cancelada."
  end

  def create
    Rails.logger.info "=== PARAMS RECIBIDOS ==="
    Rails.logger.info params.inspect
    Rails.logger.info "=== PAYMENT PARAMS ==="
    Rails.logger.info payment_params.inspect

    unless payment_params[:accept_terms] == "1" && payment_params[:accept_data] == "1"
      redirect_to new_order_payments_path(@order), alert: "Debes aceptar los términos y autorizar el tratamiento de datos." and return
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
      redirect_to new_order_payments_path(@order), alert: "Método de pago no válido" and return
    end
  end

  def status
    payment = @order.payments.last

    respond_to do |format|
      format.html do
        render :status
      end
      format.json do
        if payment.nil?
          render json: { status: "pending" }
        else
          case payment.status
          when "approved"
            render json: { status: "approved" }
          when "declined"
            render json: { status: "declined" }
          when "cancelled"
            render json: { status: "cancelled" }
          else
            render json: { status: "pending" }
          end
        end
      end
    end
  end

  def cancel
    payment = @order.payments.last
    if payment && payment.status == "pending"
      payment.update(status: "cancelled")
    end
    render json: { status: "cancelled" }
  end

  private

  def set_order
    @order = Order.find_by!(code: params[:order_code])
  end

  def payment_params
    params.require(:payment).permit(
      :payment_method, :type_card, :card_number, :exp_year,
      :exp_month, :cvc, :installments,
      :email, :card_holder, :accept_terms, :accept_data, :phone_number)
  end

  def process_card_payment(service)
    # 1. Tokenizar tarjeta
    token_response = service.tokenize_card(
      card_number: payment_params[:card_number],
      exp_month: payment_params[:exp_month].to_s.rjust(2, "0"),
      exp_year: payment_params[:exp_year].to_s[-2..],
      cvv: payment_params[:cvc],
      card_holder: payment_params[:card_holder]
    )

    puts "=== RESPUESTA DE TOKENIZACIÓN ==="
    p token_response

    if token_response["data"] && token_response["data"]["id"]
      token = token_response["data"]["id"]
      reference = "PAYMENT-#{@order.code}"
      amount_in_cents = (@order.calculate_total * 100).to_i

      # Determinar número de cuotas (1 para débito, seleccionado para crédito)
      type_card = payment_params[:type_card] || "credit"
      installments = type_card == "debit" ? 1 : (payment_params[:installments].presence || 1).to_i

      # 2. Crear transacción con el token
      response = service.create_card_transaction(
        reference: reference,
        amount_in_cents: amount_in_cents,
        customer_email: payment_params[:email],
        token: token,
        installments: installments
      )

      puts "=== RESPUESTA DE WOMPI ==="
      p response

      if response["data"]
        transaction_id = response["data"]["id"]

        @order.payments.create!(
          payment_method: :card,
          type_card: type_card,
          amount: amount_in_cents / 100.0,
          transaction_id: transaction_id,
          token: token,
          installment: installments,
          status: :pending
        )

        redirect_to status_order_payments_path(@order) and return
      else
        error_message = response["error"] ? response["error"]["messages"].values.flatten.join(", ") : "Error desconocido"
        redirect_to new_order_payments_path(@order), alert: error_message and return
      end
    else
      error_message = token_response["error"] ? token_response["error"]["messages"].values.flatten.join(", ") : "Error desconocido"
      redirect_to new_order_payments_path(@order), alert: error_message and return
    end
  end

  def process_nequi_payment(service)
    reference = "PAYMENT-#{@order.code}"
    amount_in_cents = (@order.calculate_total * 100).to_i
    phone_number = payment_params[:phone_number]

    # Validar que el teléfono sea de 10 dígitos
    unless phone_number =~ /^\d{10}$/
      redirect_to new_order_payments_path(@order), alert: "El número de teléfono debe tener 10 dígitos" and return
    end

    response = service.create_nequi_transaction(
      reference: reference,
      amount_in_cents: amount_in_cents,
      customer_email: payment_params[:email],
      phone_number: phone_number
    )

    puts "=== RESPUESTA DE NEQUI ==="
    p response

    if response["data"]
      transaction_id = response["data"]["id"]

      @order.payments.create!(
        payment_method: :nequi,
        amount: amount_in_cents / 100.0,
        transaction_id: transaction_id,
        phone_number: phone_number,
        status: :pending
      )

      redirect_to root_path, notice: "Solicitud de pago enviada. Revisa tu app de Nequi para aprobar la transacción. Una vez apruebes el pago, comenzaremos a preparar tu pedido." and return
    else
      error_message = response["error"] ? response["error"]["messages"].values.flatten.join(", ") : "Error desconocido"
      redirect_to new_order_payments_path(@order), alert: error_message and return
    end
  end

  def process_cash_payment
    begin
      ActiveRecord::Base.transaction do
        payment = @order.payments.create!(
          payment_method: :cash,
          amount: @order.total,
          status: :pending
        )

        # Forzar actualización del estado de la orden independientemente del estado previo
        # (usa el enum :pagado que ya tienes en Order)
        @order.update!(status: :pagado)

        # Si llegaste hasta aquí la transacción se comitea
      end

      redirect_to root_path,
        notice: "¡Pedido confirmado! Pagarás en efectivo #{ActionController::Base.helpers.number_to_currency(@order.total, unit: 'COP $', separator: ',', delimiter: '.')} cuando recibas tu orden."
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "[PaymentsController#process_cash_payment] Error creando pago/actualizando orden: #{e.record.errors.full_messages.join(', ')}"
      redirect_to new_order_payments_path(@order), alert: "No se pudo registrar el pago en efectivo: #{e.record.errors.full_messages.join(', ')}"
    rescue => e
      Rails.logger.error "[PaymentsController#process_cash_payment] ERROR inesperado: #{e.class} #{e.message}\n#{e.backtrace.first(5).join("\n")}"
      redirect_to new_order_payments_path(@order), alert: "Ocurrió un error al procesar el pago en efectivo."
    end
  end

  def confirm_cash_payment
    # Esta acción se ejecuta cuando el DOMICILIARIO recibe el efectivo del cliente
    payment = @order.payments.where(payment_method: :cash).last

    if payment && payment.pending? && @order.enviado?
      # Marcar la orden como pendiente de confirmación (esperando que domiciliario entregue dinero)
      @order.update!(status: :pendiente_confirmacion_pago)

      redirect_to dashboard_order_path(@order), notice: "✅ Cliente pagó en efectivo. Orden pendiente de confirmación cuando el domiciliario entregue el dinero."
    else
      redirect_to dashboard_order_path(@order), alert: "⚠️ No se puede confirmar el pago"
    end
  end

  def finalize_cash_payment
    # Esta acción se ejecuta cuando el CAJERO recibe el efectivo del domiciliario
    payment = @order.payments.where(payment_method: :cash).last

    if payment && payment.pending? && @order.pendiente_confirmacion_pago?
      # Actualizar el pago a aprobado
      payment.update!(status: :approved)
      # Marcar la orden como finalizada
      @order.update!(status: :finalizado)

      redirect_to dashboard_order_path(@order), notice: "✅ Pago en efectivo confirmado. Orden finalizada."
    else
      redirect_to dashboard_order_path(@order), alert: "⚠️ No se puede finalizar el pago"
    end
  end
end
