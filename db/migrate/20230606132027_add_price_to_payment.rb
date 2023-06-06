class AddPriceToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :price, :integer
  end
end
