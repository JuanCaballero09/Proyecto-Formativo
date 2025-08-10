class AddUniqueIndexToOrdersCode < ActiveRecord::Migration[8.0]
  def change
    add_index :orders, :code, unique: true
  end
end
