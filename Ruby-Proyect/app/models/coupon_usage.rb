class CouponUsage < ApplicationRecord
  belongs_to :user
  belongs_to :coupon

  validates :user_id, uniqueness: { scope: :coupon_id, message: "Ya uso este cupón" }
end
