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
      @order.coupon  = carrito.coupon
      @order.save!

      carrito.carrito_items.each do |ci|
        @order.order_items.create!(
          product: ci.product,
          quantity: ci.cantidad,
          price: ci.precio
        )
      end

      total = carrito.total
      @order.update!(total: total)

      if @order.coupon.present?
        success, message = @order.coupon.apply_to(current_user)
        unless success
          raise ActiveRecord::Rollback, "No se pudo aplicar el cupón: #{message}"
        end
      end

      # opcional: vaciar carrito después de crear la orden
      carrito.carrito_items.destroy_all
      carrito.update(coupon: nil)
      session[:carrito_id] = nil
    end

    redirect_to order_path(@order)
  rescue ActiveRecord::Rollback => e
    redirect_to carrito_path, alert: "No se pudo generar la orden: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to carrito_path, alert: "No se pudo generar la orden: #{e.message}"
  end

  def show
    return redirect_to root_path, alert: "Orden no encontrada" if @order.nil?
    # permiso: que sea el dueño o admin
    unless @order.user == current_user || current_user&.admin?
      redirect_to root_path, alert: "No autorizado a ver esta orden"
      return # rubocop:disable Style/RedundantReturn
    end
  end

  private

  def set_order
    # como usamos to_param -> code, buscamos por code en params[:id]
    @order = Order.find_by(code: params[:code])
  end
end
