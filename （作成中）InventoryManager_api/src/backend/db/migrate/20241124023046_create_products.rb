class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :product_code, null: false
      t.string :jan_code
      t.integer :stock_quantity, null: false, default: 0
      t.integer :standard_stock_quantity, null: false, default: 0
      t.string :order_location
      t.string :image_url
    end
  end
end
