class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers["Authorization"]

    if token.present?
      user = User.find_by(authentication_token: token)

      if user
        @current_user = user
      else
        render json: { error: "Token inválido" }, status: :unauthorized
      end
    else
      render json: { error: "Token requerido" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
