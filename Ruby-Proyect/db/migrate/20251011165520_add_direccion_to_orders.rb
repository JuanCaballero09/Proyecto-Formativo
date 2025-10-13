class AddDireccionToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :direccion, :text
  end
end
