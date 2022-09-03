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

ActiveRecord::Schema[7.0].define(version: 2022_09_02_115017) do
  create_table "meal_prep_schedule_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "作り置きアイテム", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.boolean "prepared", default: false, null: false, comment: "作成済み"
    t.integer "meal_type", null: false, comment: "作り置き種類"
    t.bigint "meal_prep_schedule_id", comment: "作り置きスケジュールID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "remaining_rate", default: 100, null: false, comment: "残量(%)"
    t.index ["meal_prep_schedule_id"], name: "index_meal_prep_schedule_items_on_meal_prep_schedule_id"
  end

  create_table "meal_prep_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "作り置きスケジュール", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "memo", comment: "メモ"
  end

  add_foreign_key "meal_prep_schedule_items", "meal_prep_schedules"
end
