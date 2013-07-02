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

ActiveRecord::Schema.define(:version => 20120729143211) do

  create_table "basecamp_accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                  :default => "", :null => false
    t.integer  "owner_id"
    t.integer  "not_valid_for_billing", :default => 1,  :null => false
  end

  add_index "basecamp_accounts", ["name"], :name => "index_basecamp_accounts_on_name", :unique => true

  create_table "basecamp_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "basecamp_account_id"
    t.string   "encrypted_api_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_columns", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "position",   :null => false
    t.integer  "project_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "basecamp_account_id",                           :null => false
    t.integer  "user_id",                                       :null => false
    t.text     "hashed_referrer",                               :null => false
    t.string   "state",                 :default => "inactive", :null => false
    t.text     "fast_spring_reference"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_item_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "basecamp_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_item_columns", :force => true do |t|
    t.integer "todo_item_id",     :null => false
    t.integer "custom_column_id", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                :null => false
    t.string   "encrypted_password", :limit => 128,                    :null => false
    t.string   "salt",               :limit => 128,                    :null => false
    t.string   "remember_token",     :limit => 128,                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified",                          :default => false, :null => false
    t.string   "verification_token", :limit => 128
  end

end
