class CarritoItemsController < ApplicationController
  def create
    @carrito = Carrito.find_or_create_by(id: session[:carrito_id])
    session[:carrito_id] ||= @carrito.id

    @producto = Product.find(params[:product_id])
    @item = @carrito.carrito_items.find_or_initialize_by(product: @producto)
    @item.cantidad ||= 0
    @item.cantidad += 1
    @item.precio = @producto.precio
    @item.save

    flash.now[:success] = "#{@producto.nombre} agregado al carrito"

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def update
    @item = CarritoItem.find(params[:id])
    @carrito = @item.carrito

    if @item.cantidad > 1
      @item.decrement!(:cantidad)
    else
      @item.destroy
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to carrito_path }
    end
  end

  def incrementar
    @item = CarritoItem.find(params[:id])
    @carrito = @item.carrito
    @item.increment!(:cantidad)

    respond_to do |format|
      format.turbo_stream { render :update } # reutiliza update.turbo_stream.erb
      format.html { redirect_to carrito_path }
    end
  end

  def destroy
    @item = CarritoItem.find(params[:id])
    @carrito = @item.carrito # << esto debe ir antes del destroy
    @item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to carrito_path }
    end
  end
end
