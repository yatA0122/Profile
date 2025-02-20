class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :workplace_id, null: false
      t.string :role, null: false
      t.string :password_digest, null: false
      t.integer :name, null: false
    end
  end
end
