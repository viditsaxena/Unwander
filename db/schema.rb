# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151011160713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "itineraries", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "description"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "location"
    t.string   "map"
    t.string   "details"
  end

  add_index "itineraries", ["user_id"], name: "index_itineraries_on_user_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.string   "name"
    t.string   "guest_phone"
    t.integer  "status",       default: 0
    t.text     "message"
    t.string   "phone_number"
    t.integer  "itinerary_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "reservations", ["itinerary_id"], name: "index_reservations_on_itinerary_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest", null: false
    t.string   "token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "email",           null: false
    t.string   "phone_number"
    t.string   "country_code"
    t.string   "area_code"
    t.string   "pic"
  end

end
