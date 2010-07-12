# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100712102156) do

  create_table "definitions", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliveries", :force => true do |t|
    t.integer  "message_id",      :null => false
    t.integer  "organization_id", :null => false
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fulfills", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "incoming",       :default => false
    t.integer  "step_id",                           :null => false
    t.datetime "sent_at"
    t.datetime "shown_at"
    t.integer  "transaction_id"
    t.integer  "request_id"
  end

  create_table "organizations", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reactions", :force => true do |t|
    t.integer  "cause_id",   :null => false
    t.integer  "effect_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reactions", ["cause_id", "effect_id"], :name => "index_reactions_on_cause_id_and_effect_id", :unique => true

  create_table "recipients", :force => true do |t|
    t.integer  "step_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "definition_id"
  end

  create_table "steps", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "start"
    t.string   "name",                         :null => false
    t.integer  "definition_id", :default => 1, :null => false
  end

  create_table "transactions", :force => true do |t|
    t.string   "title"
    t.integer  "definition_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cancelled_at"
    t.string   "uri"
    t.datetime "stopped_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.string   "password_salt",                     :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
