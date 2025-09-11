class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :codigo
      t.string :tipo_descuento
      t.decimal :valor
      t.datetime :expira_en
      t.boolean :activo, default: true

      t.timestamps
    end
  end
end
