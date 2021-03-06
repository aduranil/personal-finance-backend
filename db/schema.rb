# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180123164746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "balance", default: 0.0
  end

  create_table "authenticators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "metadata"
    t.string "institution"
    t.string "account"
    t.string "account_id"
    t.string "accounts"
    t.string "link_session_id"
    t.string "public_token"
    t.integer "user_id"
    t.jsonb "token"
  end

  create_table "filereaders", force: :cascade do |t|
    t.string "file_upload_file_name"
    t.string "file_upload_content_type"
    t.integer "file_upload_file_size"
    t.datetime "file_upload_updated_at"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description"
    t.float "amount"
    t.string "debit_or_credit"
    t.string "category_name"
    t.string "merchant_name"
    t.string "account_name"
    t.integer "account_id"
    t.date "period_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_upload_file_name"
    t.string "file_upload_content_type"
    t.integer "file_upload_file_size"
    t.datetime "file_upload_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
