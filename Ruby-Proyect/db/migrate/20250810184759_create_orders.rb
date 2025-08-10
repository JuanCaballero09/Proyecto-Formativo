class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :code
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.decimal :total
      t.references :carrito, null: false, foreign_key: true

      t.timestamps
    end
    add_index :orders, :code, unique: true
  end
end
