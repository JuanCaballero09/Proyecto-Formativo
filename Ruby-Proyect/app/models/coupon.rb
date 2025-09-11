class Coupon < ApplicationRecord
  validates :codigo, presence: true, uniqueness: true
  validates :tipo_descuento, presence: true, inclusion: { in: [ "porcentaje", "fijo" ] }
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validate :expiracion_futura

  def activo_y_no_expirado?
    activo && (expira_en.nil? || expira_en > Time.current)
  end

  private

  def expiracion_futura
    if expira_en.present? && expira_en <= Time.current
      errors.add(:expira_en, "debe ser una fecha futura")
    end
  end
end
