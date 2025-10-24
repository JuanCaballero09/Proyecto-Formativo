class ClientesController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
    @order = Order.find_by(code: params[:id])

    repond_to do |format|
      format.html { redirect_to clientes_path }
       format.json { render json: @order.as_json(include: { carrito: { include: { carrito_items: { include: :product } } }, coupon: { only: [ :codigo ] } }) }
    end
  end

  def update
  if params[:user][:password].present?
    if current_user.valid_password?(params[:user][:current_password])
      if current_user.update(user_params.except(:current_password))
        redirect_to clientes_path, notice: "Tu información y contraseña fueron actualizadas correctamente."
      else
        render :show, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "La contraseña actual es incorrecta."
      render :show, status: :unprocessable_entity
    end
  else
    # Si solo va a cambiar los datos basico 
    if current_user.update(user_params.except(:current_password, :password))
      redirect_to clientes_path, notice: "Tu información fue actualizada correctamente."
    else
      render :show, status: :unprocessable_entity
    end
  end
end

  private
  def user_params
    params.require(:user).permit(:nombre, :apellido, :telefono, :password, :password_confirmation, :current_password)
  end
end
