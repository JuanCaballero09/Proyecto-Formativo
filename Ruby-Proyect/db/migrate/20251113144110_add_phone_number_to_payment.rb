class AddPhoneNumberToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :phone_number, :string
  end
end
