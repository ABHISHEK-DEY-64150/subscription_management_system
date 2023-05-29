class RemaneTypeToServiceType < ActiveRecord::Migration[7.0]
  def change
    rename_column :packages, :type, :servicetype
  end
end
