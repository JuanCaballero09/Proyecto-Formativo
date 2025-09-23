class AddTypeToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :type, :string
    add_index :products, :type
  end
end
