namespace :mailer do
  desc "Test payment confirmation email"
  task test_payment_confirmation: :environment do
    puts "🧪 Probando correo de confirmación de pago..."

    # Buscar una orden con pago aprobado
    order = Order.joins(:payments).where(payments: { status: :approved }).first

    if order.nil?
      puts "❌ No se encontró ninguna orden con pago aprobado."
      puts "   Creando orden de prueba..."

      # Crear una orden de prueba
      order = Order.create!(
        code: "ORD-#{Date.current.strftime('%Y%m%d')}-TEST123",
        status: :pagado,
        total: 45000,
        direccion: "Calle de Prueba 123 #45-67, Bogotá",
        guest_nombre: "Juan Carlos",
        guest_apellido: "Test",
        guest_email: "test@ejemplo.com",
        guest_telefono: "+57 300 123 4567"
      )

      # Crear items de prueba
      if Product.exists?
        products = Product.limit(2)
        products.each_with_index do |product, index|
          order.order_items.create!(
            product: product,
            quantity: index + 1,
            price: product.precio
          )
        end
        order.update!(total: order.order_items.sum { |item| item.quantity * item.price })
      end

      # Crear pago de prueba
      order.payments.create!(
        amount: order.total,
        payment_method: "CARD",
        transaction_id: "TEST-#{SecureRandom.hex(8).upcase}",
        status: :approved
      )

      puts "✅ Orden de prueba creada: #{order.code}"
    end

    # Enviar el correo
    begin
      OrdersMailer.payment_confirmation(order).deliver_now
      puts "✅ Correo enviado exitosamente a: #{order.customer_email}"
      puts "   Orden: #{order.code}"
      puts "   Total: $#{order.total}"
    rescue => e
      puts "❌ Error al enviar correo: #{e.message}"
      puts "   Verifica la configuración SMTP en config/environments/development.rb"
    end
  end
end
