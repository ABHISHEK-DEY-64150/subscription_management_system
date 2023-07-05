class AddAddressToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :address, :text
  end
end
