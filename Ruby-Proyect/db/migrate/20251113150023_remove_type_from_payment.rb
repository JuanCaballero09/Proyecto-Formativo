class RemoveTypeFromPayment < ActiveRecord::Migration[8.0]
  def change
    remove_column :payments, :type, :integer
  end
end
