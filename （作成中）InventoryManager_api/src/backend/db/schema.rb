# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_12_20_065043) do
  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_code", null: false
    t.string "jan_code"
    t.integer "stock_quantity", default: 0, null: false
    t.integer "standard_stock_quantity", default: 0, null: false
    t.string "order_location"
    t.string "image_url"
    t.bigint "workplace_id"
    t.index ["workplace_id"], name: "fk_rails_b4c2bc7e5c"
  end

  create_table "stock_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "quantity_changed"
    t.string "changed_by"
    t.bigint "workplace_id"
    t.index ["product_id"], name: "index_stock_logs_on_product_id"
    t.index ["workplace_id"], name: "fk_rails_ff231e9bfa"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "workplace_id", null: false
    t.string "role"
    t.string "password_digest", null: false
    t.string "name"
  end

  add_foreign_key "products", "users", column: "workplace_id"
  add_foreign_key "stock_logs", "products"
  add_foreign_key "stock_logs", "users", column: "workplace_id"
end
