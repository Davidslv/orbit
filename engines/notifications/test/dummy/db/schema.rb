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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_181521) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "notifications_notifications", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "read_at"
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["recipient_type", "recipient_id"], name: "idx_on_recipient_type_recipient_id_3e3867b7ca"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
