class AddIdColumnStockLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_logs, :workplace_id, :string
  end
end
