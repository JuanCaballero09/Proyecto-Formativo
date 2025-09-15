class AddCouponIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :coupon, null: false, foreign_key: true
  end
end
