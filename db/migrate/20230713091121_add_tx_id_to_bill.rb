class AddTxIdToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :txid, :string
  end
end
