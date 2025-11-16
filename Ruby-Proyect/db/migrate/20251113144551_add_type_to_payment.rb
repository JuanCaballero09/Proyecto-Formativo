class AddTypeToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :type, :integer
  end
end
