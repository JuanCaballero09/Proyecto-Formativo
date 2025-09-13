class CarritosController < ApplicationController
  before_action :authenticate_user!

  def show
    @carrito = Carrito.find_by(id: session[:carrito_id])
    @items = @carrito&.carrito_items || []
    @total_productos = @items.sum(:cantidad)
    @total_precio = @items.sum(:precio)
  end

  def aplicar_cupon
    @carrito = Carrito.find_by(id: session[:carrito_id])
    cupon = Coupon.find_by(codigo: params[:codigo])

    if @carrito && cupon
      if cupon.usable_by?(current_user)
        @carrito.update(coupon: cupon)
        flash.now[:notice] = "Cupón aplicado correctamente ✅"
      else
        if !cupon.activo_y_no_expirado?
          flash.now[:alert] = "El cupón no es válido o está vencido ❌"
        elsif CouponUsage.exists?(user: current_user, coupon: cupon)
          flash.now[:alert] = "Ya usaste este cupón ❌"
        else
          flash.now[:alert] = "No se puede aplicar el cupón ❌"
        end
      end
    else
      flash.now[:alert] = "Cupón inválido ❌"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to carrito_path(@carrito) }
    end
  end

  def quitar_cupon
    @carrito = Carrito.find_by(id: session[:carrito_id])

    if @carrito&.coupon.present?
      @carrito.update(coupon: nil)
      flash.now[:notice] = "Cupón eliminado 🗑️"
    else
      flash.now[:alert] = "No hay cupón para quitar ❌"
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to carrito_path(@carrito) }
    end
  end
end
