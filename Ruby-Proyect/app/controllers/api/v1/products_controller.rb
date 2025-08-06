class Api::V1::ProductsController < ApplicationController
  
  def index
    producto = Product.all.order(:id)
    render json: producto.as_json
  end
end
