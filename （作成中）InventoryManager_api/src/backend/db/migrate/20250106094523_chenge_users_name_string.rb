class ChengeUsersNameString < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :name, :string
  end
end
