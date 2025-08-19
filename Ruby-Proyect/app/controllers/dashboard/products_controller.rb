class Dashboard::ProductsController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_admin

  def index
    if params[:query].present?
    query = I18n.transliterate(params[:query].downcase.strip)
    @products = Product.all.select do |p|
      I18n.transliterate(p.nombre.downcase).include?(query)
    end.sort_by(&:id)
    else
      @products = Product.order(:id)
    end
  end

  def new
    @product = Product.new
    @ingredientes = Ingrediente.all
  end

  def edit
    @product = Product.find(params[:id])
    @ingredientes = Ingrediente.all
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to dashboard_products_path, notice: "Producto eliminado exitosamente."
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to dashboard_products_path,
      notice: "El producto fue creado exitosamente."
    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to dashboard_products_path, notice: "Producto actualizado"
    else
    render :edit
    end
  end

  def toggle_disponibilidad # <-- Cambia el nombre aquí
    @product = Product.find(params[:id])
    @product.update(disponible: !@product.disponible)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_products_path, notice: "Producto actualizado" }
    end
  end

  def product_params
    params.require(:product).permit(:nombre, :precio, :descripcion, :grupo_id, :imagen, :disponible, ingrediente_ids: [])
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :nombre,
      :precio,
      :descripcion,
      :imagen,
      :grupo_id,
      :disponible,
      :calificacion,
      ingrediente_ids: []
    )
  end

  def check_admin
    unless current_user.admin? # Verifica si el usuario tiene rol de admin
      redirect_to root_path, alert: "No tienes acceso a esta página."
    end
  end
end
