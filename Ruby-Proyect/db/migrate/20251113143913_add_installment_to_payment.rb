class AddInstallmentToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :installment, :integer
  end
end
