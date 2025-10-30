class OrdersMailer < ApplicationMailer
  default from: "biteviasoftware@gmail.com" # Esto es de donde van a salir los correos hacia las personas que olviden su contraseña
  layout "mailer"

  def payment_confirmation(order)
    @order = order
    @payment = order.payments.approved.last
    @customer_email = order.customer_email
    @customer_name = order.customer_name

    mail(
      to: @customer_email,
      subject: I18n.t("mailers.orders_mailer.payment_confirmation.subject", order_code: @order.code)
    )
  end
end
