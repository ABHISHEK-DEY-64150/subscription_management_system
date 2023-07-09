class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :provider_id
      t.integer :customer_id
      t.integer :package_id
      t.string :packdescription
      t.integer :price
      t.integer :amount
      t.integer :fine
      t.integer :status
      t.date :date
      t.date :due_date

      t.timestamps
    end
  end
end
