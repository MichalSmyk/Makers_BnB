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

ActiveRecord::Schema[7.0].define(version: 2023_01_20_115317) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "stay_date", precision: nil
    t.datetime "request_time", precision: nil
    t.string "request_approval"
    t.integer "space_id"
    t.integer "user_id"
  end

  create_table "space_dates", force: :cascade do |t|
    t.datetime "date_available", precision: nil
    t.integer "space_id"
    t.string "available?"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.money "price", scale: 2
    t.string "address"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mobile_number"
  end

  add_foreign_key "bookings", "spaces"
  add_foreign_key "bookings", "users"
  add_foreign_key "space_dates", "spaces"
  add_foreign_key "spaces", "users"
end
