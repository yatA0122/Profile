class AddPrice < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :price, :integer
  end
end
