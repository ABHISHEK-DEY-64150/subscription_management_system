class AddServicetypeToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :servicetype, :string
  end
end
