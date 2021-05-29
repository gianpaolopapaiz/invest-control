# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_29_025211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "funds", force: :cascade do |t|
    t.string "short_name"
    t.string "cnpj"
    t.string "class"
    t.string "performance_text"
    t.date "buy_date"
    t.integer "buy_quantity"
    t.float "buy_price"
    t.string "strategy"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.bigint "stock_id", null: false
    t.bigint "fund_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fund_id"], name: "index_portfolios_on_fund_id"
    t.index ["stock_id"], name: "index_portfolios_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "short_name"
    t.string "symbol"
    t.string "strategy"
    t.date "buy_date"
    t.integer "buy_quantity"
    t.float "buy_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "portfolios", "funds"
  add_foreign_key "portfolios", "stocks"
end