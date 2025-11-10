class Dashboard::IngredientesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_ingrediente, only: [:edit, :update, :destroy] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets

  def index
    if params[:query].present?
      query = I18n.transliterate(params[:query].downcase.strip)
      @ingredientes = Ingrediente.all.select do |i|
        I18n.transliterate(i.nombre.downcase).include?(query)
      end.sort_by(&:id)
    else
      @ingredientes = Ingrediente.order(:id)
    end
    @ingredientes_paginado = Ingrediente.order(:id).page(params[:page]).per(10)
  end

  def new
    @ingrediente = Ingrediente.new
  end

  def create
    @ingrediente = Ingrediente.new(ingrediente_params)
    if @ingrediente.save
      redirect_to dashboard_ingredientes_path, notice: "Ingrediente creado exitosamente."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ingrediente.update(ingrediente_params)
      redirect_to dashboard_ingredientes_path, notice: "Ingrediente actualizado."
    else
      render :edit
    end
  end

  def destroy
    @ingrediente.destroy
    redirect_to dashboard_ingredientes_path, notice: "Ingrediente eliminado."
  end

  private

  def set_ingrediente
    @ingrediente = Ingrediente.find(params[:id])
  end

  def ingrediente_params
    params.require(:ingrediente).permit(:nombre)
  end

  def check_admin
    redirect_to root_path, alert: "No tienes acceso a esta página." unless current_user.admin?
  end
end
