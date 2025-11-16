class Product < ApplicationRecord
  belongs_to :grupo, optional: true

  has_many :ingrediente_productos, dependent: :destroy
  has_many :ingredientes, through: :ingrediente_productos
  has_many :carrito_items, dependent: :destroy
  has_many :carritos, through: :carrito_items
  has_many :order_items, dependent: :restrict_with_error
  has_many :orders, through: :order_items
  has_many :combo_items, foreign_key: :product_id, dependent: :restrict_with_error

  validates :nombre, :descripcion, :precio, presence: true

  before_create :asignar_id_menor

  has_one_attached :imagen

  # Método para obtener la URL de la imagen
  def imagen_url
    if imagen.attached?
      Rails.application.routes.url_helpers.rails_blob_path(imagen, only_path: true)
    else
      nil
    end
  end

  def imagen_resized
    return unless imagen.attached?

    imagen.variant(resize_to_fill: [ 300, 200 ]).processed
  end

  def imagen_resized2
    return unless imagen.attached?

    imagen.variant(resize_to_fill: [ 400, 300 ]).processed
  end

  private

  def asignar_id_menor
    # Buscar la menor ID libre
    ids_existentes = Product.pluck(:id).sort
    posible_id = 1

    ids_existentes.each do |id|
      break if id != posible_id
      posible_id += 1
    end

    self.id = posible_id
  end
end
