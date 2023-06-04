class AddPackageIdToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :package_id, :integer
  end
end
