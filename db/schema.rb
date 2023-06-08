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

ActiveRecord::Schema[7.0].define(version: 2023_06_06_132027) do
  create_table "customer_subscriptions", force: :cascade do |t|
    t.string "servicetype"
    t.string "packagedescription"
    t.integer "price"
    t.integer "package_id"
    t.integer "provider_id"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dues"
    t.index ["customer_id"], name: "index_customer_subscriptions_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "paymentDues"
    t.integer "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_customers_on_provider_id"
  end

  create_table "my_services", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "provider_id", null: false
    t.integer "package_id", null: false
    t.string "servicetype"
    t.string "package"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_my_services_on_package_id"
    t.index ["provider_id"], name: "index_my_services_on_provider_id"
    t.index ["user_id"], name: "index_my_services_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "servicetype"
    t.text "description"
    t.integer "price"
    t.integer "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_packages_on_provider_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "customer_id"
    t.integer "subscription_id"
    t.integer "amount"
    t.date "timestamp"
    t.text "txid"
    t.integer "dues"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card"
    t.integer "package_id"
    t.string "servicetype"
    t.string "packagedescription"
    t.integer "price"
  end

  create_table "providers", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "customer_subscriptions", "customers"
  add_foreign_key "customers", "providers"
  add_foreign_key "my_services", "packages"
  add_foreign_key "my_services", "providers"
  add_foreign_key "my_services", "users"
  add_foreign_key "packages", "providers"
end
