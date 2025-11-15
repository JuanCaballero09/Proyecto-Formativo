# app/controllers/orders/payments_controller.rb
class  Orders::PaymentsController < ApplicationController
  layout "application_min"
  protect_from_forgery with: :null_session
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
    unless payment_params[:accept_terms] == "1" && payment_params[:accept_data] == "1"
      redirect_to new_order_payments_path(@order), alert: "Debes aceptar los términos y autorizar el tratamiento de datos." and return
    end

    service = WompiService.new
    payment_method_type = payment_params[:payment_method_type] || "card"

    case payment_method_type
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
      :payment_method_type, :type_card, :card_number, :exp_year,
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
    # Crear el pago en efectivo con status pending
    @order.payments.create!(
      payment_method: :cash,
      amount: @order.total,
      status: :pending
    )

    # Actualizar orden a pendiente (esperando preparación y entrega)
    @order.update(status: :pendiente)

    # Redirigir a página de confirmación
    redirect_to root_path, notice: "¡Pedido confirmado! Pagarás en efectivo al recibir tu orden. Total a pagar: #{ActionController::Base.helpers.number_to_currency(@order.total, unit: 'COP ', separator: ',', delimiter: '.')}"
  end
end
