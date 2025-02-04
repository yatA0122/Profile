class AddIdColumnProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :workplace_id, :string
  end
end
