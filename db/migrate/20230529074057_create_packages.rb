class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :type
      t.text :description
      t.integer :price
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
