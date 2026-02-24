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

ActiveRecord::Schema[7.0].define(version: 2026_02_24_060822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "balance", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
  end

  create_table "approvals", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "approver_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["approver_id"], name: "index_approvals_on_approver_id"
    t.index ["deleted_at"], name: "index_approvals_on_deleted_at"
    t.index ["expense_id", "approver_id"], name: "index_approvals_on_expense_and_approver", unique: true
    t.index ["expense_id"], name: "index_approvals_on_expense_id"
    t.index ["status"], name: "index_approvals_on_status"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "action", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id"
    t.jsonb "metadata", default: {}
    t.string "ip_address"
    t.string "request_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_companies_on_subdomain", unique: true
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.text "description"
    t.string "status", default: "pending", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["deleted_at"], name: "index_expenses_on_deleted_at"
    t.index ["status"], name: "index_expenses_on_status"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "platform_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", default: "", null: false
    t.string "role", default: "super_admin", null: false
    t.index ["email"], name: "index_platform_users_on_email", unique: true
    t.index ["jti"], name: "index_platform_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_platform_users_on_reset_password_token", unique: true
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.string "file_url"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_receipts_on_expense_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.string "transaction_type", null: false
    t.string "status", default: "completed", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "idempotency_key"
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["deleted_at"], name: "index_transactions_on_deleted_at"
    t.index ["idempotency_key"], name: "index_transactions_on_idempotency_key", unique: true
    t.index ["status"], name: "index_transactions_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "role", default: "employee", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "approvals", "expenses"
  add_foreign_key "approvals", "users", column: "approver_id"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "users"
  add_foreign_key "receipts", "expenses"
  add_foreign_key "transactions", "accounts"
end
