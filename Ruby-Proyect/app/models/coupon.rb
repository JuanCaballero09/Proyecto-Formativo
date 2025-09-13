class Coupon < ApplicationRecord
  has_many :coupon_usages
  has_many :users, through: :coupon_usages
  validates :codigo, presence: true, uniqueness: true
  validates :tipo_descuento, presence: true, inclusion: { in: [ "porcentaje", "fijo" ] }
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validate :expiracion_futura

  def activo_y_no_expirado?
    activo && (expira_en.nil? || expira_en > Time.current)
  end

  def usable_by?(user)
    return false unless activo_y_no_expirado?
    return false if CouponUsage.exists?(user: user, coupon: self)
    true
  end

  def apply_to(user)
    return "Cupón vencido" if expira_en.present? && expira_en <= Time.current
    return "Ya usaste este cupón" if coupon_usages.exists?(user: user)

    begin
      coupon_usages.create!(user: user, used_at: Time.current)
      "Cupón aplicado con éxito"
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      # Si por alguna carrera de concurrencia el registro ya existe
      "Ya usaste este cupón"
    end
  end

  private

  def expiracion_futura
    if expira_en.present? && expira_en <= Time.current
      errors.add(:expira_en, "debe ser una fecha futura")
    end
  end
end
