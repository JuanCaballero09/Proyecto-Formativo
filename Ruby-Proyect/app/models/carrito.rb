class Carrito < ApplicationRecord
  has_many :carrito_items, dependent: :destroy
  has_many :products, through: :carrito_items
  belongs_to :coupon, optional: true

  before_create :generar_numero_orden

  def subtotal
    carrito_items.sum("precio * cantidad")
  end

  def descuento
    return 0 unless coupon&.activo_y_no_expirado?
    if coupon.tipo_descuento == "fijo"
      [ coupon.valor, subtotal ].min
    elsif coupon.tipo_descuento == "porcentaje"
      (subtotal * coupon.valor / 100.0).round(2)
    end
  end

  def total
    subtotal - descuento
  end

  private

  def generar_numero_orden
    self.numero_orden ||= "CARR-#{SecureRandom.hex(4).upcase}"
  end
end
