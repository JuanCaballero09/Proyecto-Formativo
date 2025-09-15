class AddUniqueIndexToCouponUsages < ActiveRecord::Migration[8.0]
  def change
    add_index :coupon_usages, [ :user_id, :coupon_id ], unique: true, name: "index_unique_user_coupon_usages"
  end
end
