class CouponRedemption < ApplicationRecord
  belongs_to :coupon
  belongs_to :user

  validates :user_id, uniqueness: { scope: :coupon_id, message: "ya usó este cupón" }
end
