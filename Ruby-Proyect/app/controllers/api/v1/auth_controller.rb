class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token # Para API no necesitamos CSRF

  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      if user.active_for_authentication?
        render json: {
          token: user.authentication_token,
          user: {
            id: user.id,
            nombre: user.nombre,
            apellido: user.apellido,
            email: user.email,
            rol: user.rol
          }
        }, status: :ok
      else
        render json: { error: "Cuenta no confirmada o inactiva" }, status: :unauthorized
      end
    else
      render json: { error: "Credenciales inválidas" }, status: :unauthorized
    end
  end

  def logout
    user = User.find_by(authentication_token: request.headers["Authorization"])

    if user
      user.update(authentication_token: SecureRandom.hex(20)) # invalidamos token actual
      render json: { message: "Sesión cerrada correctamente" }, status: :ok
    else
      render json: { error: "Token inválido" }, status: :unauthorized
    end
  end
end
