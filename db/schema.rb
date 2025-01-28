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

ActiveRecord::Schema[7.0].define(version: 2025_01_28_053908) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "event_dates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_number"
    t.string "date_weekday"
    t.string "date_month"
    t.bigint "chesed_train_id"
    t.string "special_note"
    t.bigint "volunteer_id"
    t.text "bringing"
    t.datetime "full_date"
    t.index ["chesed_train_id"], name: "index_event_dates_on_chesed_train_id"
    t.index ["volunteer_id"], name: "index_event_dates_on_volunteer_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "recipent_email"
    t.string "recipent_name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.integer "adults"
    t.integer "kids"
    t.string "allergies"
    t.string "preferred_time"
    t.string "dietary_restrictions"
    t.text "special_message"
    t.bigint "owner_id"
    t.string "type"
    t.string "least"
    t.string "shabbat_instructions"
    t.string "fav_rest"
    t.integer "step"
    t.string "country"
    t.string "postal_code"
    t.integer "status", default: 0, null: false
    t.jsonb "date_range"
    t.index ["owner_id"], name: "index_events_on_owner_id"
  end

  create_table "selections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "quantity", default: 0
    t.string "special_note"
    t.string "placeholder"
    t.bigint "potluck_id"
    t.bigint "volunteer_id"
    t.string "bringing"
    t.index ["potluck_id"], name: "index_selections_on_potluck_id"
    t.index ["volunteer_id"], name: "index_selections_on_volunteer_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "updates", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_updates_on_event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.boolean "updates", default: true
    t.boolean "tos"
    t.boolean "sms"
    t.boolean "guest", default: false
    t.boolean "is_paying", default: false
    t.boolean "is_admin", default: false
    t.string "country_code"
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "volunteer_events", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_volunteer_events_on_event_id"
    t.index ["user_id"], name: "index_volunteer_events_on_user_id"
  end

  add_foreign_key "event_dates", "users", column: "volunteer_id"
  add_foreign_key "events", "users", column: "owner_id"
  add_foreign_key "selections", "users", column: "volunteer_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "updates", "events"
  add_foreign_key "volunteer_events", "users", on_delete: :cascade
end
