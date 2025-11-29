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

  has_one_attached :imagen do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 150, 150 ], preprocessed: true
    attachable.variant :medium, resize_to_limit: [ 400, 300 ], preprocessed: true
    attachable.variant :display, resize_to_fill: [ 600, 400 ], preprocessed: true
  end

  # Método para obtener la URL de la imagen
  def imagen_url
    return nil unless imagen.attached?
    Rails.application.routes.url_helpers.rails_blob_path(imagen, only_path: true)
  end

  # Variante optimizada para tarjetas de producto (con compresión)
  def imagen_resized
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 300, 200 ],
      format: :webp,
      saver: { quality: 85, strip: true }
    ).processed
  end

  # Thumbnail optimizado para listados
  def imagen_thumbnail
    return unless imagen.attached?
    imagen.variant(
      resize_to_limit: [ 150, 150 ],
      format: :webp,
      saver: { quality: 80, strip: true }
    ).processed
  end

  # Imagen mediana para detalles
  def imagen_resized2
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 400, 300 ],
      format: :webp,
      saver: { quality: 85, strip: true }
    ).processed
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
