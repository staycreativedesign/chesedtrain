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

ActiveRecord::Schema[7.2].define(version: 2025_04_24_200913) do
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

  create_table "ads", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "views", default: 0
    t.integer "clicks", default: 0
    t.string "zipcode"
    t.string "country"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location", default: "top"
    t.boolean "paused", default: false
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
    t.datetime "potluck_date"
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
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "area_code"
    t.string "toke", default: "d8019630e15ecfe883e8"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_dates", "users", column: "volunteer_id"
  add_foreign_key "events", "users", column: "owner_id"
  add_foreign_key "selections", "users", column: "volunteer_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "updates", "events"
  add_foreign_key "volunteer_events", "users", on_delete: :cascade

  create_view "user_reports", sql_definition: <<-SQL
      WITH selected_countries(country_name, country_code) AS (
           VALUES ('United States'::text,'+1'::text), ('Argentina'::text,'+54'::text), ('Australia'::text,'+61'::text), ('Austria'::text,'+43'::text), ('Belarus'::text,'+375'::text), ('Belgium'::text,'+32'::text), ('Belize'::text,'+501'::text), ('Benin'::text,'+229'::text), ('Bhutan'::text,'+975'::text), ('Bolivia'::text,'+591'::text), ('Brazil'::text,'+55'::text), ('Brunei'::text,'+673'::text), ('Canada'::text,'+1c'::text), ('Chile'::text,'+56'::text), ('Colombia'::text,'+57'::text), ('Comoros'::text,'+269'::text), ('Congo'::text,'+242'::text), ('Costa Rica'::text,'+506'::text), ('Croatia'::text,'+385'::text), ('Cuba'::text,'+53'::text), ('Cyprus'::text,'+357'::text), ('Czech Republic'::text,'+420'::text), ('Denmark'::text,'+45'::text), ('Ecuador'::text,'+593'::text), ('Egypt'::text,'+20'::text), ('El Salvador'::text,'+503'::text), ('Finland'::text,'+358'::text), ('France'::text,'+33'::text), ('Georgia'::text,'+995'::text), ('Germany'::text,'+49'::text), ('Greece'::text,'+30'::text), ('Guatemala'::text,'+502'::text), ('Haiti'::text,'+509'::text), ('Honduras'::text,'+504'::text), ('Hungary'::text,'+36'::text), ('Iceland'::text,'+354'::text), ('Iran'::text,'+98'::text), ('Iraq'::text,'+964'::text), ('Ireland'::text,'+353'::text), ('Israel'::text,'+972'::text), ('Italy'::text,'+39'::text), ('Jamaica'::text,'+1-876'::text), ('Japan'::text,'+81'::text), ('Jordan'::text,'+962'::text), ('Lebanon'::text,'+961'::text), ('Mexico'::text,'+52'::text), ('Monaco'::text,'+377'::text), ('Mongolia'::text,'+976'::text), ('Morocco'::text,'+212'::text), ('Netherlands'::text,'+31'::text), ('New Zealand'::text,'+64'::text), ('Peru'::text,'+51'::text), ('Philippines'::text,'+63'::text), ('Poland'::text,'+48'::text), ('Portugal'::text,'+351'::text), ('Qatar'::text,'+974'::text), ('Romania'::text,'+40'::text), ('Russia'::text,'+7'::text), ('Saudi Arabia'::text,'+966'::text), ('Singapore'::text,'+65'::text), ('South Africa'::text,'+27'::text), ('Spain'::text,'+34'::text), ('Sweden'::text,'+46'::text), ('Switzerland'::text,'+41'::text), ('Thailand'::text,'+66'::text), ('Turkey'::text,'+90'::text), ('Ukraine'::text,'+380'::text), ('United Arab Emirates'::text,'+971'::text), ('United Kingdom'::text,'+44'::text)
          )
   SELECT (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS full_name,
      users.email_address,
      ((users.area_code)::text || (users.phone_number)::text) AS contact_number,
      users.is_paying AS pro,
      users.sms,
      users.created_at,
      selected_countries.country_name,
      count(events.*) AS event_created,
      count(volunteer_events.*) AS volunteered_events
     FROM (((users
       LEFT JOIN events ON ((users.id = events.owner_id)))
       LEFT JOIN volunteer_events ON ((users.id = volunteer_events.user_id)))
       LEFT JOIN selected_countries ON (((users.country_code)::text = selected_countries.country_code)))
    WHERE (users.guest = false)
    GROUP BY users.id, users.first_name, users.last_name, users.email_address, users.area_code, users.phone_number, users.is_paying, users.created_at, selected_countries.country_name;
  SQL
  create_view "ad_reports", sql_definition: <<-SQL
      WITH country_codes(country_name, country_code) AS (
           VALUES ('United States'::text,'+1'::text), ('Argentina'::text,'+54'::text), ('Australia'::text,'+61'::text), ('Austria'::text,'+43'::text), ('Belarus'::text,'+375'::text), ('Belgium'::text,'+32'::text), ('Belize'::text,'+501'::text), ('Benin'::text,'+229'::text), ('Bhutan'::text,'+975'::text), ('Bolivia'::text,'+591'::text), ('Brazil'::text,'+55'::text), ('Brunei'::text,'+673'::text), ('Canada'::text,'+1c'::text), ('Chile'::text,'+56'::text), ('Colombia'::text,'+57'::text), ('Comoros'::text,'+269'::text), ('Congo'::text,'+242'::text), ('Costa Rica'::text,'+506'::text), ('Croatia'::text,'+385'::text), ('Cuba'::text,'+53'::text), ('Cyprus'::text,'+357'::text), ('Czech Republic'::text,'+420'::text), ('Denmark'::text,'+45'::text), ('Ecuador'::text,'+593'::text), ('Egypt'::text,'+20'::text), ('El Salvador'::text,'+503'::text), ('Finland'::text,'+358'::text), ('France'::text,'+33'::text), ('Georgia'::text,'+995'::text), ('Germany'::text,'+49'::text), ('Greece'::text,'+30'::text), ('Guatemala'::text,'+502'::text), ('Haiti'::text,'+509'::text), ('Honduras'::text,'+504'::text), ('Hungary'::text,'+36'::text), ('Iceland'::text,'+354'::text), ('Iran'::text,'+98'::text), ('Iraq'::text,'+964'::text), ('Ireland'::text,'+353'::text), ('Israel'::text,'+972'::text), ('Italy'::text,'+39'::text), ('Jamaica'::text,'+1-876'::text), ('Japan'::text,'+81'::text), ('Jordan'::text,'+962'::text), ('Lebanon'::text,'+961'::text), ('Mexico'::text,'+52'::text), ('Monaco'::text,'+377'::text), ('Mongolia'::text,'+976'::text), ('Morocco'::text,'+212'::text), ('Netherlands'::text,'+31'::text), ('New Zealand'::text,'+64'::text), ('Peru'::text,'+51'::text), ('Philippines'::text,'+63'::text), ('Poland'::text,'+48'::text), ('Portugal'::text,'+351'::text), ('Qatar'::text,'+974'::text), ('Romania'::text,'+40'::text), ('Russia'::text,'+7'::text), ('Saudi Arabia'::text,'+966'::text), ('Singapore'::text,'+65'::text), ('South Africa'::text,'+27'::text), ('Spain'::text,'+34'::text), ('Sweden'::text,'+46'::text), ('Switzerland'::text,'+41'::text), ('Thailand'::text,'+66'::text), ('Turkey'::text,'+90'::text), ('Ukraine'::text,'+380'::text), ('United Arab Emirates'::text,'+971'::text), ('United Kingdom'::text,'+44'::text)
          )
   SELECT ads.id,
      ads.name,
      ads.start_date,
      ads.end_date,
      ads.views,
      ads.clicks,
      ads.zipcode,
      ads.country,
      ads.link,
      ads.created_at,
      ads.updated_at,
      country_codes.country_name
     FROM (ads
       LEFT JOIN country_codes ON (((ads.country)::text = country_codes.country_code)));
  SQL
  create_view "event_reports", sql_definition: <<-SQL
      SELECT events.name AS event_name,
      events.type AS event_type,
      (((users.first_name)::text || ' '::text) || (users.last_name)::text) AS owner,
      users.email_address AS email,
      (((users.area_code)::text || ' '::text) || (users.phone_number)::text) AS contact_number,
      events.start_date,
      events.end_date,
      events.recipent_email AS recipient_email,
      events.recipent_name AS recipient_name,
      events.country,
      events.postal_code,
      events.state,
      events.created_at,
      count(volunteer_events.id) AS volunteer_count
     FROM ((events
       JOIN users ON ((events.owner_id = users.id)))
       LEFT JOIN volunteer_events ON ((events.id = volunteer_events.event_id)))
    WHERE (users.guest = false)
    GROUP BY events.id, users.id;
  SQL
end
