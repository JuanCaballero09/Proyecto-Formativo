class ProductsController < ApplicationController
  def index
    @products = Product.includes(:grupo).where(disponible: true).order(:grupo_id, :id)
  end

  def combos
    @combos = Product.where(type: "Combo", disponible: true).order(created_at: :desc)
  end
end
