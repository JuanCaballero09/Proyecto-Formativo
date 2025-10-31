# Preview all emails at http://localhost:3000/rails/mailers/orders_mailer
class OrdersMailerPreview < ActionMailer::Preview
  def payment_confirmation
    # Buscar una orden con pago aprobado, o crear datos de ejemplo
    order = Order.joins(:payments).where(payments: { status: :approved }).first

    if order.nil?
      # Crear datos de ejemplo si no hay órdenes con pago aprobado
      order = Order.new(
        code: "ORD-#{Date.current.strftime('%Y%m%d')}-DEMO123",
        status: :pagado,
        total: 45000,
        direccion: "Calle 123 #45-67, Bogotá",
        created_at: Time.current,
        guest_nombre: "Juan Carlos",
        guest_apellido: "Pérez",
        guest_email: "demo@ejemplo.com",
        guest_telefono: "+57 300 123 4567"
      )

      # Simular items del pedido
      order.order_items.build(
        quantity: 2,
        price: 15000,
        product: OpenStruct.new(nombre: "Hamburguesa Clásica")
      )
      order.order_items.build(
        quantity: 1,
        price: 15000,
        product: OpenStruct.new(nombre: "Pizza Hawaiana")
      )

      # Simular pago
      payment = Payment.new(
        amount: 45000,
        payment_method: "CARD",
        transaction_id: "TXN-DEMO-123456",
        status: :approved
      )
      order.payments = [ payment ]
    end

    OrdersMailer.payment_confirmation(order)
  end
end
