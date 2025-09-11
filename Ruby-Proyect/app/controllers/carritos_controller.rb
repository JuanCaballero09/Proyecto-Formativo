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

    if cupon&.activo_y_no_expirado?
      @carrito.update(coupon: cupon)
      flash.now[:notice] = "Cupón aplicado correctamente."
    else
      flash.now[:alert] = "Cupón inválido o expirado."
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @carrito }
    end
  end

  def quitar_cupon
    @carrito = Carrito.find(params[:id])
    @carrito.update(coupon: nil)
    flash.now[:notice] = "Cupón eliminado."

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @carrito }
    end
  end
end
