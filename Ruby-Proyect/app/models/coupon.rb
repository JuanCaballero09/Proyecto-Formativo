class Coupon < ApplicationRecord
  has_many :coupon_redemptions
  has_many :users, through: :coupon_redemptions

  enum :discount_type, {
    porcentaje: 0,
    fijo: 1
  }

  validates :code, presence: true, uniqueness: true
  validates :discount_type, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :expires_at, presence: true

  validate :validate_discount_value

  private

  def validate_discount_value
    if porcentaje? && (discount_value < 1 || discount_value > 100)
      errors.add(:discount_value, "debe estar entre 1 y 100 si es porcentaje")
    end
  end
end
