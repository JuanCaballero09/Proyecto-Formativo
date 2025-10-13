class AddGuestFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :guest_nombre, :string
    add_column :orders, :guest_apellido, :string
    add_column :orders, :guest_telefono, :string
    add_column :orders, :guest_email, :string
  end
end
