class Api::V1::GruposController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  def index
    grupo = Grupo.all.order(:id)
    render json: grupo.map { |grupo|
      grupo.as_json.merge(
        imagen_url: grupo.imagen.attached? ? url_for(grupo.imagen) : nil
      )
    }
  end

  def show
    grupo = Grupo.find(params[:id])
    render json: grupo.as_json.merge(
      imagen_url: grupo.imagen.attached? ? url_for(grupo.imagen) : nil
    )
  end
end
