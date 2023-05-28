class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :paymentDues
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
 