class CreateComboItems < ActiveRecord::Migration[8.0]
  def change
    create_table :combo_items do |t|
      t.references :combo, null: false, foreign_key: { to_table: :products }
      t.references :product, null: false, foreign_key: true
      t.integer :cantidad, null: false, default: 1

      t.timestamps
    end
    add_index :combo_items, [:combo_id, :product_id], unique: true
  end
end
