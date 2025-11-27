class Dashboard::BannersController < ApplicationController
  layout "dashboard"

  before_action :authenticate_user!
  before_action :check_admin

  def index
    @banners = Banner.includes(imagen_attachment: :blob).order(:id)
  end

  def new
    @banner = Banner.new
  end
  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to dashboard_banners_path, notice: "El banner fue creado exitosamente"
    else
      render new
    end
  end

  def edit
    @grupo = Grupo.find(params[:id])
  end

  def destroy
    banner = Banner.find(params[:id])
    banner.destroy
    redirect_to dashboard_banners_path, notice: "Bane eliminado exitosamente."
  end

  private

  def banner_params
    params.require(:banner).permit(:imagen)
  end

  def check_admin
    redirect_to root_path, alert: "No tienes acceso a esta página." unless current_user.admin?
  end
end
