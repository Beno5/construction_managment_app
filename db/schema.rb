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

ActiveRecord::Schema[7.0].define(version: 2025_11_17_192157) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.integer "activity_type"
    t.integer "quantity"
    t.date "start_date"
    t.date "end_date"
    t.decimal "total_cost"
    t.bigint "sub_task_id", null: false
    t.bigint "activityable_id"
    t.string "activityable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sub_task_id"], name: "index_activities_on_sub_task_id"
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone_number"
    t.string "vat_number"
    t.string "registration_number"
    t.string "owner_first_name"
    t.string "owner_last_name"
    t.jsonb "custom_fields", default: {}
    t.integer "currency"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_businesses_on_user_id_and_name", unique: true
  end

  create_table "custom_resources", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "profession"
    t.decimal "fixed_costs", precision: 10, scale: 2
    t.integer "quantity"
    t.string "unit_of_measure"
    t.decimal "price_per_unit"
    t.decimal "total_cost"
    t.text "description"
    t.integer "category"
    t.bigint "sub_task_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.index ["sub_task_id"], name: "index_custom_resources_on_sub_task_id"
    t.index ["user_id"], name: "index_custom_resources_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "category", default: 0
    t.bigint "project_id"
    t.bigint "task_id"
    t.bigint "sub_task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_documents_on_project_id"
    t.index ["sub_task_id"], name: "index_documents_on_sub_task_id"
    t.index ["task_id"], name: "index_documents_on_task_id"
  end

  create_table "links", force: :cascade do |t|
    t.integer "source_id"
    t.integer "target_id"
    t.string "link_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "machines", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "unit_of_measure", default: 0, null: false
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.decimal "fixed_costs", precision: 10, scale: 2
    t.jsonb "custom_fields", default: {}
    t.bigint "business_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "average_daily_hours"
    t.index ["business_id"], name: "index_machines_on_business_id"
    t.index ["user_id"], name: "index_machines_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.integer "unit_of_measure", default: 0, null: false
    t.jsonb "custom_fields", default: {}
    t.bigint "business_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["business_id"], name: "index_materials_on_business_id"
    t.index ["user_id"], name: "index_materials_on_user_id"
  end

  create_table "norms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "info"
    t.integer "norm_type", default: 0, null: false
    t.integer "subtype"
    t.string "unit_of_measure"
    t.decimal "norm_value", precision: 10, scale: 4
    t.string "tags", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id"
    t.bigint "user_id"
    t.jsonb "custom_fields", default: {}
    t.boolean "auto_calculate"
    t.index ["business_id"], name: "index_norms_on_business_id"
    t.index ["user_id"], name: "index_norms_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "project_manager"
    t.date "planned_start_date"
    t.date "planned_end_date"
    t.decimal "planned_cost"
    t.date "real_start_date"
    t.date "real_end_date"
    t.decimal "real_cost"
    t.integer "status", default: 0
    t.jsonb "custom_fields", default: {}
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.index ["business_id"], name: "index_projects_on_business_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "real_activities", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "total_cost"
    t.date "start_date"
    t.date "end_date"
    t.bigint "activity_id", null: false
    t.bigint "user_id", null: false
    t.bigint "sub_task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_real_activities_on_activity_id"
    t.index ["sub_task_id"], name: "index_real_activities_on_sub_task_id"
    t.index ["user_id"], name: "index_real_activities_on_user_id"
  end

  create_table "sub_task_norms", force: :cascade do |t|
    t.bigint "sub_task_id", null: false
    t.bigint "norm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["norm_id"], name: "index_sub_task_norms_on_norm_id"
    t.index ["sub_task_id"], name: "index_sub_task_norms_on_sub_task_id"
  end

  create_table "sub_tasks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "planned_start_date"
    t.date "planned_end_date"
    t.decimal "planned_cost"
    t.date "real_start_date"
    t.date "real_end_date"
    t.decimal "real_cost"
    t.jsonb "custom_fields", default: {}
    t.bigint "user_id", null: false
    t.decimal "progress", default: "0.0"
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "planned_auto_calculation", default: true
    t.boolean "real_auto_calculation", default: true
    t.integer "position"
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.integer "unit_of_measure", default: 0
    t.integer "quantity"
    t.decimal "total_cost"
    t.decimal "duration", precision: 10, scale: 2
    t.decimal "num_workers_skilled", precision: 10, scale: 2
    t.decimal "num_workers_unskilled", precision: 10, scale: 2
    t.decimal "num_machines", precision: 10, scale: 2
    t.index ["task_id"], name: "index_sub_tasks_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "planned_start_date"
    t.date "planned_end_date"
    t.decimal "planned_cost"
    t.date "real_start_date"
    t.date "real_end_date"
    t.decimal "real_cost"
    t.jsonb "custom_fields", default: {}
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "progress", default: "0.0"
    t.integer "position"
    t.decimal "duration", precision: 10, scale: 2
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
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
    t.string "name"
    t.string "locale"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "profession"
    t.text "description"
    t.integer "unit_of_measure", default: 0, null: false
    t.decimal "price_per_unit", precision: 10, scale: 2
    t.boolean "is_team", default: false
    t.jsonb "custom_fields", default: {}
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.float "average_daily_hours"
    t.index ["business_id"], name: "index_workers_on_business_id"
    t.index ["user_id"], name: "index_workers_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "sub_tasks"
  add_foreign_key "businesses", "users"
  add_foreign_key "custom_resources", "sub_tasks"
  add_foreign_key "custom_resources", "users"
  add_foreign_key "documents", "projects"
  add_foreign_key "documents", "sub_tasks"
  add_foreign_key "documents", "tasks"
  add_foreign_key "machines", "businesses"
  add_foreign_key "machines", "users"
  add_foreign_key "materials", "businesses"
  add_foreign_key "materials", "users"
  add_foreign_key "norms", "businesses"
  add_foreign_key "norms", "users"
  add_foreign_key "projects", "businesses"
  add_foreign_key "projects", "users"
  add_foreign_key "real_activities", "activities"
  add_foreign_key "real_activities", "sub_tasks"
  add_foreign_key "real_activities", "users"
  add_foreign_key "sub_task_norms", "norms"
  add_foreign_key "sub_task_norms", "sub_tasks"
  add_foreign_key "sub_tasks", "tasks"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
  add_foreign_key "workers", "businesses"
  add_foreign_key "workers", "users"
end
