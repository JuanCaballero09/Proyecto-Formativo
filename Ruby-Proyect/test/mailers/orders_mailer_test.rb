require "test_helper"

class OrdersMailerTest < ActionMailer::TestCase
  test "payment_confirmation email" do
    # Crear una orden de ejemplo
    order = orders(:one) # Asumiendo que tienes fixtures

    # Crear un pago aprobado para la orden
    order.payments.create!(
      amount: order.total,
      payment_method: "CARD",
      transaction_id: "TEST-123456",
      status: :approved
    )

    # Generar el email
    email = OrdersMailer.payment_confirmation(order)

    # Verificar que el email se envía
    assert_emails 1 do
      email.deliver_now
    end

    # Verificar el contenido del email
    assert_equal [ "biteviasoftware@gmail.com" ], email.from
    assert_equal [ order.customer_email ], email.to
    assert_equal "✅ Confirmación de pago - Pedido #{order.code}", email.subject
    assert_match order.code, email.body.to_s
    assert_match order.customer_name, email.body.to_s
  end
end
