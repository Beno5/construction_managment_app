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

ActiveRecord::Schema[7.0].define(version: 2024_12_27_232356) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_businesses_on_user_id"
  end

  create_table "machines", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "machine_type"
    t.text "description"
    t.boolean "is_occupied"
    t.bigint "business_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_machines_on_business_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "project_type"
    t.string "address"
    t.string "project_manager"
    t.date "planned_start_date"
    t.date "planned_end_date"
    t.decimal "estimated_cost"
    t.text "description"
    t.string "attachment"
    t.jsonb "custom_fields"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.index ["business_id"], name: "index_projects_on_business_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "quantity"
    t.string "unit"
    t.date "planned_start_date"
    t.date "planned_end_date"
    t.decimal "planned_cost"
    t.jsonb "custom_fields"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "terms"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "profession"
    t.text "description"
    t.date "hired_on"
    t.decimal "salary"
    t.decimal "hourly_rate"
    t.integer "contract_hours_per_month"
    t.string "phone_number"
    t.jsonb "custom_fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.index ["business_id"], name: "index_workers_on_business_id"
  end

  add_foreign_key "businesses", "users"
  add_foreign_key "machines", "businesses"
  add_foreign_key "projects", "businesses"
  add_foreign_key "tasks", "projects"
  add_foreign_key "workers", "businesses"
end
