# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 18) do

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "clients", :force => true do |t|
    t.string   "code",                       :default => "", :null => false
    t.string   "name",                       :default => "", :null => false
    t.string   "cif"
    t.string   "contact"
    t.text     "address"
    t.string   "city"
    t.string   "province"
    t.string   "postcode"
    t.string   "country"
    t.string   "phone",        :limit => 18
    t.string   "fax"
    t.string   "email"
    t.text     "observations"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "discounts", :force => true do |t|
    t.integer  "client_id"
    t.float    "value",      :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "discounts", ["client_id"], :name => "index_discounts_on_client_id"
  add_index "discounts", ["value"], :name => "index_discounts_on_value"

  create_table "estimates", :force => true do |t|
    t.integer  "client_id",                                 :null => false
    t.date     "delivery_date",   :default => '2013-07-15'
    t.date     "expiration_date", :default => '2013-08-14'
    t.integer  "tax_id"
    t.text     "observations"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "user_id"
    t.integer  "number",          :default => 20130715,     :null => false
  end

  add_index "estimates", ["client_id"], :name => "index_estimates_on_client_id"
  add_index "estimates", ["delivery_date"], :name => "index_estimates_on_delivery_date"
  add_index "estimates", ["expiration_date"], :name => "index_estimates_on_expiration_date"
  add_index "estimates", ["number"], :name => "index_estimates_on_number", :unique => true
  add_index "estimates", ["tax_id"], :name => "index_estimates_on_tax_id"

  create_table "invoices", :force => true do |t|
    t.integer  "client_id",                                   :null => false
    t.date     "expiration_date",   :default => '2013-07-22', :null => false
    t.integer  "payment_method_id"
    t.string   "status",            :default => "Pendiente"
    t.text     "observations"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "number",            :default => 20130726,     :null => false
  end

  add_index "invoices", ["client_id"], :name => "index_invoices_on_client_id"
  add_index "invoices", ["number"], :name => "index_invoices_on_number", :unique => true
  add_index "invoices", ["payment_method_id"], :name => "index_invoices_on_payment_method_id"
  add_index "invoices", ["status"], :name => "index_invoices_on_status"

  create_table "item_products", :force => true do |t|
    t.integer  "item_id"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.float    "price",      :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "estimate_id"
    t.integer  "invoice_id"
    t.integer  "product_id"
    t.integer  "quantity",    :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "line_items", ["estimate_id"], :name => "index_line_items_on_estimate_id"
  add_index "line_items", ["invoice_id"], :name => "index_line_items_on_invoice_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"
  add_index "line_items", ["quantity"], :name => "index_line_items_on_quantity"

  create_table "payment_methods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "payment_methods", ["name"], :name => "index_payment_methods_on_name"

  create_table "prices", :force => true do |t|
    t.integer  "product_id"
    t.float    "value",      :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "prices", ["product_id"], :name => "index_prices_on_product_id"
  add_index "prices", ["value"], :name => "index_prices_on_value"

  create_table "products", :force => true do |t|
    t.integer  "code",        :limit => 8
    t.string   "name",                     :default => "", :null => false
    t.text     "description"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "products", ["code"], :name => "index_products_on_code", :unique => true
  add_index "products", ["name"], :name => "index_products_on_name"

  create_table "projects", :force => true do |t|
    t.integer  "estimate_id"
    t.text     "description",                             :null => false
    t.integer  "estimation_time_in_days", :default => 30
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "rates", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "tax_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rates", ["invoice_id"], :name => "index_rates_on_invoice_id"
  add_index "rates", ["tax_id"], :name => "index_rates_on_tax_id"

  create_table "taxes", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "taxes", ["name"], :name => "index_taxes_on_name"
  add_index "taxes", ["value"], :name => "index_taxes_on_value"

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "",     :null => false
    t.string   "role",                   :default => "user", :null => false
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.integer  "zone_id",                :default => 7
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "name",                   :default => "",     :null => false
    t.string   "surname",                :default => "",     :null => false
    t.string   "pid"
    t.string   "phone"
    t.text     "address"
    t.text     "observations"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["role"], :name => "index_users_on_role"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true
  add_index "users", ["zone_id"], :name => "index_users_on_zone_id"

end
