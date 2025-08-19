class Dashboard::UsersController < ApplicationController
  layout "dashboard"

  before_action :check_admin
  def index
    @users = User.all.order(:id)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      respond_to do |format|
        flash.now[:notice] = "Usuario actualizado correctamente."
        format.turbo_stream
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Error al actualizar el usuario."
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "dashboard/users/user", locals: { user: @user }) }
      end
    end
  end

  private

  def check_admin
    unless current_user.admin? # Verifica si el usuario tiene rol de admin
      redirect_to root_path, alert: "No tienes acceso a esta página."
    end
  end

  def user_params
    params.require(:user).permit(:activo, :rol)
  end
end
