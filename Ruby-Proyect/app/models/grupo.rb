class Grupo < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :nombre, :descripcion, presence: true

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
