class AddInvoiceToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :invoicepdf, :binary
  end
end
