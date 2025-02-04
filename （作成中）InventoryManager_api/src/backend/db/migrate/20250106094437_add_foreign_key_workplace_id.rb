class AddForeignKeyWorkplaceId < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :workplace_id, :bigint
    change_column :stock_logs, :workplace_id, :bigint
    add_foreign_key :products, :users, column: :workplace_id
    add_foreign_key :stock_logs, :users, column: :workplace_id
  end
end
