class Dashboard::ProductsController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_admin

  def index
    if params[:query].present?
      query = I18n.transliterate(params[:query].downcase.strip)
      all_products = Product.all.select do |p|
        I18n.transliterate(p.nombre.downcase).include?(query)
      end

      @combos = all_products.select { |p| p.type == "Combo" }.sort_by(&:id)
      @productos_por_grupo = all_products.reject { |p| p.type == "Combo" }
                                       .group_by(&:grupo)
                                       .sort_by { |grupo, _| grupo&.id || 0 }
    else
      @combos = Product.where(type: "Combo").order(:id)
        @productos_por_grupo = Product.where(type: [ nil, "" ])
                                    .includes(:grupo)
                                    .group_by(&:grupo)
                                    .sort_by { |grupo, _| grupo&.id || 0 }
                                                            
    end
    @products_paginado = Product.where(type: [nil, ""])
                                      .includes(:grupo)
                                      .order(:id)
                                      .page(params[:page])
                                      .per(10)
  end

  def new
    @product = params[:type] == "Combo" ? Combo.new : Product.new

    # Para nuevos combos, agregar un combo_item vacío para el formulario
    if @product.is_a?(Combo)
      @product.combo_items.build
    end

    @ingredientes = Ingrediente.all
    @products_for_combo = Product.where(type: [ nil, "" ])
  end

  def edit
    @product = Product.find(params[:id])

    # Para combos sin componentes, agregar un combo_item vacío para el formulario
    if @product.is_a?(Combo) && @product.combo_items.empty?
      @product.combo_items.build
    end

    @ingredientes = Ingrediente.all
    @products_for_combo = Product.where(type: [ nil, "" ])
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to dashboard_products_path, notice: "Producto eliminado exitosamente."
  end

  def create
    if params[:product][:type] == "Combo"
      @product = Combo.new(product_params)
      # Si no se asigna grupo, buscar o crear el grupo "Combos"
      if @product.grupo_id.blank?
        combos_group = Grupo.find_by(nombre: "Combos") ||
                      Grupo.find_by(nombre: "combo") ||
                      Grupo.find_by(nombre: "COMBOS") ||
                      Grupo.find_or_create_by(nombre: "Combos") do |grupo|
                        grupo.descripcion = "Grupo para combos y promociones especiales"
                      end
        @product.grupo_id = combos_group.id
      end
    else
      @product = Product.new(product_params)
    end

    if @product.save
      redirect_to dashboard_products_path, notice: "#{@product.type == 'Combo' ? 'Combo' : 'Producto'} creado exitosamente."
    else
      @ingredientes = Ingrediente.all
      @products_for_combo = Product.where(type: [ nil, "" ])
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

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    base_params = [
      :nombre,
      :precio,
      :descripcion,
      :imagen,
      :grupo_id,
      :disponible,
      :calificacion,
      :type,
      ingrediente_ids: []
    ]

    if params.dig(:product, :type) == "Combo"
      base_params << { combo_items_attributes: [ :id, :product_id, :cantidad, :_destroy ] }
    end

    params.require(:product).permit(base_params)
  end

  def check_admin
    unless current_user.admin? # Verifica si el usuario tiene rol de admin
      redirect_to root_path, alert: "No tienes acceso a esta página."
    end
  end
end
