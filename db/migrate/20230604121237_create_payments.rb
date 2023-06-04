class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :provider_id
      t.integer :customer_id
      t.integer :subscription_id
      t.integer :amount
      t.date :timestamp
      t.text :txid
      t.integer :dues

      t.timestamps
    end
  end
end
