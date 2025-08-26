# app/controllers/orders/payments_controller.rb
class  Orders::PaymentsController < ApplicationController
  layout "application_min"
  protect_from_forgery with: :null_session
  before_action :set_order

  def new
    @payment = @order.payments.new
  end


  def create
    service = WompiService.new

    # 1. tokenizar tarjeta
    token_response = service.tokenize_card(
      card_number: payment_params[:card_number],
      exp_month: payment_params[:exp_month].to_s.rjust(2, "0"),
      exp_year: payment_params[:exp_year].to_s[-2..],
      cvv: payment_params[:cvv],
      card_holder: payment_params[:card_holder]
    )

    puts "=== RESPUESTA DE TOKENIZACIÓN ==="
    p token_response

    if token_response["data"] && token_response["data"]["id"]
      token = token_response["data"]["id"]

      # 2. Crear transacción con el token
      reference = "PAYMENT-#{@order.code}"
      amount_in_cents = (@order.total * 100).to_i

      response = service.create_card_transaction(
        reference: reference,
        amount_in_cents: amount_in_cents,
        customer_email: payment_params[:email],
        token: token,
        installments: payment_params[:installments].to_i || 1
      )

      puts "=== RESPUESTA DE WOMPI ==="
      p response

      if response["data"]
        transaction_id = response["data"]["id"]

        @order.payments.create!(
          amount: amount_in_cents / 100.0,
          payment_method: "CARD",
          transaction_id: transaction_id,
          token: token
        )
        # render json: { status: "success", transaction_id: transaction_id, wompi: response }
        redirect_to status_order_payments_path(@order) and return
      else
        error_message = response["error"] ? response["error"]["messages"].values.flatten.join(", ") : "Error desconocido"
        render json: { status: "error", message: error_message }, status: :unprocessable_entity
      end
    else
      error_message = token_response["error"] ? token_response["error"]["messages"].values.flatten.join(", ") : "Error desconocido"
      render json: { status: "error", message: error_message }, status: :unprocessable_entity
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
    params.require(:payment).permit(:payment_method, :card_number, :exp_year, :exp_month, :cvv, :installments, :email, :card_holder)
  end
end
