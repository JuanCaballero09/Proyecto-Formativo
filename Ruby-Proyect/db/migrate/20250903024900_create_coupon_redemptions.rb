class CreateCouponRedemptions < ActiveRecord::Migration[8.0]
  def change
    create_table :coupon_redemptions do |t|
      t.references :coupon, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :redeemed_at

      t.timestamps
    end
  end
end
