class AddCardToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :card, :integer
  end
end
