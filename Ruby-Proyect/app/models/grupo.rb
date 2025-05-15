class Grupo < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :nombre, presence: true

  before_create :asignar_id_menor

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
