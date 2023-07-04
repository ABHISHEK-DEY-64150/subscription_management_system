class AddSubscriptionDateToCustomerSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :customer_subscriptions, :subscriptiondate, :date
  end
end
