class CreateCustomerSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_subscriptions do |t|
      t.string :servicetype
      t.string :packagedescription
      t.integer :price
      t.integer :package_id
      t.integer :provider_id
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
