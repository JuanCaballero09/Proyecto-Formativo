# app/controllers/orders/payments_controller.rb
class Orders::PaymentsController < ApplicationController
  layout "application_min"
  protect_from_forgery with: :null_session
  before_action :set_order

  def new
    @payment = @order.payments.new
  end


  def create
    puts "=== PARAMS RECIBIDOS ==="
    p params

    puts "=== ORDEN ENCONTRADA ==="
    p @order

    service = WompiService.new

    reference = "PAYMENT-#{@order.code}"
    amount_in_cents = (@order.total * 100).to_i
    email = "juanes09212006@gmail.com" # cambiar a futuro por current_user.email
    token = "tok_test_1723386_1534CB194f22c73e3572675F075256fE" # token de prueba de Wompi, cambiar a futuro
    installments = 1 # cuotas, cambiar a futuro

    response = service.create_card_transaction(
      reference: reference,
      amount_in_cents: amount_in_cents,
      customer_email: email,
      token: token,
      installments: installments
    )

    puts "=== RESPUESTA DE WOMPI ==="
    p response

    if response["data"]
        transaction_id = response["data"]["id"]

        @order.payments.create!(
          amount: amount_in_cents / 100.0,
          payment_method: "CARD",
          transaction_id: transaction_id
        )

        render json: { status: "success", transaction_id: transaction_id, wompi: response }
    else
        render json: { status: "error", details: response }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find_by!(code: params[:order_code])
  end

  def payment_params
    params.require(:payment).permit(:amount, :payment_method, :transaction_id)
  end
end
