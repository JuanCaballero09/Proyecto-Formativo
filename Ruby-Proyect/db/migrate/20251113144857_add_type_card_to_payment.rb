class AddTypeCardToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :type_card, :integer
  end
end
