class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :transaction_id
      t.integer :status, default: 0  # para usar enum en el modelo
      t.decimal :amount, precision: 10, scale: 2
      t.string :payment_method
      t.string :token

      t.timestamps
    end
  end
end
