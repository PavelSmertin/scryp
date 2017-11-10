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

ActiveRecord::Schema.define(version: 20171110041303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coins", force: :cascade do |t|
    t.string "name"
    t.text "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "logo"
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
    t.index ["coin_id"], name: "index_events_on_coin_id"
  end

  create_table "newests", force: :cascade do |t|
    t.string "link"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.index ["event_id"], name: "index_newests_on_event_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.text "link"
    t.json "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "coins"
  add_foreign_key "newests", "events"
end
