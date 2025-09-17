class Api::V1::Grupos::ProductsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show] # rubocop:disable Layout/SpaceInsideArrayLiteralBrackets
  def index
    grupo = Grupo.find(params[:grupo_id])
    producto = grupo.products.order(:id)
    render json: producto.map { |producto|
      producto.as_json.merge(
        imagen_url: producto.imagen.attached? ? url_for(producto.imagen) : nil,
        ingredientes: producto.ingredientes.pluck(:nombre)
      )
    }
  end

  def show
    grupo = Grupo.find(params[:grupo_id])
    producto = grupo.products.find(params[:id]) # busca el producto dentro del grupo

    render json: producto.as_json.merge(
      imagen_url: producto.imagen.attached? ? url_for(producto.imagen) : nil,
      ingredientes: producto.ingredientes.pluck(:nombre)
    )
  end
end
