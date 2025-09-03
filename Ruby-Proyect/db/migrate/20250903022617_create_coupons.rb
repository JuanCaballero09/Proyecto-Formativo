class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.integer :discount_type, null: false
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.datetime :expires_at
      t.boolean :active, null: false, default: true
      t.boolean :redeemed, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
