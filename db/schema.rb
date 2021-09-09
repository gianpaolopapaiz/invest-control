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

ActiveRecord::Schema.define(version: 2021_09_09_225556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cdis", force: :cascade do |t|
    t.float "value_month"
    t.float "value_day"
    t.date "date_update"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date_tax"
    t.float "value_year"
  end

  create_table "funds", force: :cascade do |t|
    t.string "short_name"
    t.string "cnpj"
    t.string "fund_class"
    t.string "performance_text"
    t.date "buy_date"
    t.float "buy_quantity"
    t.float "buy_price"
    t.string "strategy"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "portfolio_id", null: false
    t.string "advisor"
    t.float "actual_price"
    t.date "actual_date"
    t.string "cnpj_clean"
    t.index ["portfolio_id"], name: "index_funds_on_portfolio_id"
  end

  create_table "ipcas", force: :cascade do |t|
    t.float "value_month"
    t.float "value_day"
    t.float "value_year"
    t.date "date_tax"
    t.date "date_update"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.date "update_values_date"
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "prefixeds", force: :cascade do |t|
    t.string "short_name"
    t.string "description"
    t.string "strategy"
    t.date "buy_date"
    t.float "buy_quantity"
    t.float "buy_price"
    t.float "actual_price"
    t.date "actual_date"
    t.string "advisor"
    t.float "year_tax"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "portfolio_id", null: false
    t.index ["portfolio_id"], name: "index_prefixeds_on_portfolio_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "short_name"
    t.string "symbol"
    t.string "strategy"
    t.date "buy_date"
    t.float "buy_quantity"
    t.float "buy_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "portfolio_id", null: false
    t.float "actual_price"
    t.date "actual_date"
    t.string "advisor"
    t.index ["portfolio_id"], name: "index_stocks_on_portfolio_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.date "update_values_date", default: "2010-01-01"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "funds", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "prefixeds", "portfolios"
  add_foreign_key "stocks", "portfolios"
end
