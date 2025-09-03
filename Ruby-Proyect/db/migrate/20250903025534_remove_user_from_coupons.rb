class RemoveUserFromCoupons < ActiveRecord::Migration[8.0]
  def change
    remove_reference :coupons, :user, null: false, foreign_key: true
    remove_column :coupons, :redeemed, :boolean, default: false, null: false
  end
end
