class ChangeCouponIdNullableInOrders < ActiveRecord::Migration[8.0]
  def change
      change_column_null :orders, :coupon_id, true
  end
end
