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

ActiveRecord::Schema[8.1].define(version: 2026_03_17_181656) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "billing_invoices", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "GBP", null: false
    t.date "due_date"
    t.datetime "paid_at"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_billing_invoices_on_user_id"
  end

  create_table "billing_plans", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "interval"
    t.string "name"
    t.integer "price_cents"
    t.datetime "updated_at", null: false
  end

  create_table "billing_subscriptions", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.bigint "plan_id", null: false
    t.datetime "started_at"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["plan_id"], name: "index_billing_subscriptions_on_plan_id"
    t.index ["user_id"], name: "index_billing_subscriptions_on_user_id"
  end

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

  add_foreign_key "billing_subscriptions", "billing_plans", column: "plan_id"
end
