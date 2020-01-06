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

ActiveRecord::Schema.define(version: 20160816070426) do

  create_table "amazon_order_references", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "amazon_order_reference_id"
    t.string   "authorization_reference_id"
    t.string   "capture_reference_id"
    t.string   "amazon_authorization_id"
    t.string   "amount"
    t.string   "destination_state_or_region"
    t.string   "destination_city"
    t.string   "destination_phone"
    t.string   "destination_country_code"
    t.string   "destination_postal_code"
    t.string   "destination_name"
    t.string   "destination_address_line1"
    t.string   "destination_address_line2"
    t.string   "destination_address_line3"
    t.string   "buyer_name"
    t.string   "buyer_email"
    t.string   "order_reference_status"
    t.string   "order_reference_status_reason_code"
    t.string   "authorization_status"
    t.string   "authorization_status_reason_code"
    t.string   "capture_status"
    t.string   "capture_status_reason_code"
    t.text     "authorization_result"
    t.text     "capture_result"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "cancel_status_reason_code"
  end

end
