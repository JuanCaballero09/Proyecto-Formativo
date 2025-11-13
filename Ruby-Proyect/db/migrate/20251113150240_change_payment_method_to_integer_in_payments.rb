class ChangePaymentMethodToIntegerInPayments < ActiveRecord::Migration[8.0]
  def change
    change_column :payments, :payment_method, :integer, default: 0, using: 'payment_method::integer'
  end
end
