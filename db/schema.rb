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

ActiveRecord::Schema[7.1].define(version: 4) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_product_parts", force: :cascade do |t|
    t.bigint "custom_product_id", null: false
    t.bigint "part_id", null: false
    t.bigint "part_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_product_id"], name: "index_custom_product_parts_on_custom_product_id"
    t.index ["part_id"], name: "index_custom_product_parts_on_part_id"
    t.index ["part_option_id"], name: "index_custom_product_parts_on_part_option_id"
  end

  create_table "custom_products", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.bigint "catalog_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_product_id"], name: "index_custom_products_on_catalog_product_id"
  end

  create_table "part_options", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.string "option"
    t.boolean "in_stock", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_part_options_on_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "part_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_parts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.bigint "catalog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_id"], name: "index_products_on_catalog_id"
  end

  add_foreign_key "custom_product_parts", "custom_products"
  add_foreign_key "custom_product_parts", "part_options"
  add_foreign_key "custom_product_parts", "parts"
  add_foreign_key "custom_products", "products", column: "catalog_product_id"
  add_foreign_key "part_options", "parts"
  add_foreign_key "parts", "products"
  add_foreign_key "products", "products", column: "catalog_id"
end
