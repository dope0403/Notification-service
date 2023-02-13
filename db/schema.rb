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

ActiveRecord::Schema[7.0].define(version: 2023_02_13_055330) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.integer "employee_id"
    t.string "message"
    t.integer "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employee_email"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.integer "employee_id", null: false
    t.integer "meeting_id", null: false
    t.integer "status", null: false
    t.string "employee_email", null: false
    t.string "room"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "time", precision: nil
  end

  create_table "orders", force: :cascade do |t|
    t.integer "employee_id"
    t.string "employee_name"
    t.integer "order_id"
    t.integer "duration"
    t.string "chef_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employee_email"
  end

  create_table "pantries", force: :cascade do |t|
    t.integer "order_id"
    t.integer "employee_id"
    t.string "employee_name"
    t.string "chef_name"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_ids", id: :serial, force: :cascade do |t|
    t.integer "emp_id"
    t.string "slack_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "emp_name"
  end

end
