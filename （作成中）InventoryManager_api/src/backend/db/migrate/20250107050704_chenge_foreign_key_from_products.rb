class ChengeForeignKeyFromProducts < ActiveRecord::Migration[7.0]
  def change
    # workplace_id の型を string に変更
    change_column :products, :workplace_id, :string

    add_index :users, :workplace_id, unique: true
    
    # 外部キーが存在する場合のみ削除
    if foreign_key_exists?(:products, :users, column: :workplace_id)
      remove_foreign_key :products, :users, column: :workplace_id
    end

    # インデックスが存在する場合のみ削除
    if index_exists?(:products, :workplace_id, name: "fk_rails_b4c2bc7e5c")
      remove_index :products, name: "fk_rails_b4c2bc7e5c"
    end

    # 新しい外部キーを追加
    add_foreign_key :products, :users, column: :workplace_id, primary_key: :workplace_id
  end
end