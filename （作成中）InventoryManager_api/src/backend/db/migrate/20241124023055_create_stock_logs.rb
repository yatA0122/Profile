class CreateStockLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_logs do |t|
      t.references :product, foreign_key: true
      t.integer :quantity_changed
      t.string :changed_by
    end
  end
end
