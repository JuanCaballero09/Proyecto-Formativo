class OrdersController < ApplicationController
  layout "application_min"

  before_action :authenticate_user!  # exige login
  before_action :set_order, only: [ :show ]

  def create
    carrito = Carrito.find_by(id: session[:carrito_id])
    if carrito.nil? || carrito.carrito_items.empty?
      redirect_to carrito_path, alert: "Tu carrito está vacío" and return
    end

    ActiveRecord::Base.transaction do
      @order = current_user.orders.build(status: :pendiente, total: 0)
      @order.carrito = carrito if carrito.respond_to?(:id)
      @order.save!

      carrito.carrito_items.each do |ci|
        @order.order_items.create!(
          product: ci.product,
          quantity: ci.cantidad,
          price: ci.precio
        )
      end

      total = @order.order_items.sum("quantity * price")
      @order.update!(total: total)

      # opcional: vaciar carrito después de crear la orden
      carrito.carrito_items.destroy_all
    end

    redirect_to order_path(@order)
  rescue ActiveRecord::RecordInvalid => e
    redirect_to carrito_path, alert: "No se pudo generar la orden: #{e.message}"
  end

  def show
    # permiso: que sea el dueño o admin
    unless @order.user == current_user || current_user&.admin?
      redirect_to root_path, alert: "No autorizado a ver esta orden"
      nil
    end
    # la vista usará @order y @order.order_items
  end

  private

  def set_order
    # como usamos to_param -> code, buscamos por code en params[:id]
    @order = Order.find_by!(code: params[:id])
  end
end
