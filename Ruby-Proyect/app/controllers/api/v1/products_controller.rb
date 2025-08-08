class Api::V1::ProductsController < ApplicationController
  
  def index
    producto = Product.all.order(:id)
    render json: producto.map { |producto|
      producto.as_json.merge(
        imagen_url: producto.imagen.attached? ? url_for(producto.imagen) : nil
      )
    }
  end
end
