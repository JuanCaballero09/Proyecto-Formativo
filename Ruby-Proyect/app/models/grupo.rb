class Grupo < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :nombre, :descripcion, presence: true

  before_create :asignar_id_menor

  has_one_attached :imagen do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 150, 150 ], preprocessed: true
    attachable.variant :card, resize_to_fill: [ 300, 300 ], preprocessed: true
  end

  # Método para obtener la URL de la imagen
  def imagen_url
    return nil unless imagen.attached?
    Rails.application.routes.url_helpers.rails_blob_path(imagen, only_path: true)
  end

  # Variante optimizada para tarjetas de categoría
  def imagen_resized
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 300, 300 ],
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

  private

  def asignar_id_menor
    # Buscar la menor ID libre
    ids_existentes = Grupo.pluck(:id).sort
    posible_id = 1

    ids_existentes.each do |id|
      break if id != posible_id
      posible_id += 1
    end

    self.id = posible_id
  end
end
