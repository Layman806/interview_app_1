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

ActiveRecord::Schema[7.1].define(version: 2023_10_25_152748) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_requests", force: :cascade do |t|
    t.jsonb "request_params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colleges", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exam_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exam_window_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_window_id"], name: "index_exam_registrations_on_exam_window_id"
    t.index ["user_id", "exam_window_id"], name: "index_exam_registrations_on_user_id_and_exam_window_id"
    t.index ["user_id"], name: "index_exam_registrations_on_user_id"
  end

  create_table "exam_windows", force: :cascade do |t|
    t.date "start_time", null: false
    t.date "end_time", null: false
    t.bigint "exam_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_windows_on_exam_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "college_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_exams_on_college_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name", "phone_number"], name: "index_users_on_first_name_and_last_name_and_phone_number"
  end

  add_foreign_key "exam_registrations", "exam_windows"
  add_foreign_key "exam_registrations", "users"
  add_foreign_key "exam_windows", "exams"
  add_foreign_key "exams", "colleges"
end
