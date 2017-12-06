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

ActiveRecord::Schema.define(version: 20171206100027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "coins", force: :cascade do |t|
    t.json "logo"
    t.string "symbol"
    t.string "coin_name"
    t.string "full_name"
    t.string "algorithm"
    t.string "proof_type"
    t.decimal "fully_premined", precision: 22
    t.decimal "total_coin_supply", precision: 22
    t.decimal "pre_mined_value", precision: 22
    t.decimal "total_coins_free_float", precision: 22
    t.integer "sort_order"
    t.boolean "sponsored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "describtion"
    t.string "link"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "coin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_events_on_category_id"
    t.index ["coin_id"], name: "index_events_on_coin_id"
  end

  create_table "newests", force: :cascade do |t|
    t.string "link"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.string "image"
    t.index ["event_id"], name: "index_newests_on_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "categories"
  add_foreign_key "events", "coins"
  add_foreign_key "newests", "events"
end
