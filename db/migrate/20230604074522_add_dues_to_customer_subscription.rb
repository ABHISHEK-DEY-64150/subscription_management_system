class AddDuesToCustomerSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :customer_subscriptions, :dues, :integer
  end
end
