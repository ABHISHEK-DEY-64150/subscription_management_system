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

ActiveRecord::Schema[7.0].define(version: 2023_07_12_063714) do
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

  create_table "bills", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "customer_id"
    t.integer "package_id"
    t.string "packdescription"
    t.integer "price"
    t.integer "amount"
    t.integer "fine"
    t.integer "status"
    t.date "date"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.date "subscriptiondate"
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
    t.text "address"
    t.index ["provider_id"], name: "index_customers_on_provider_id"
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
    t.binary "invoicepdf"
  end

  create_table "providers", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "provider_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reply"
    t.index ["customer_id"], name: "index_reviews_on_customer_id"
    t.index ["provider_id"], name: "index_reviews_on_provider_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "customer_subscriptions", "customers"
  add_foreign_key "customers", "providers"
  add_foreign_key "packages", "providers"
  add_foreign_key "reviews", "customers"
  add_foreign_key "reviews", "providers"
end
