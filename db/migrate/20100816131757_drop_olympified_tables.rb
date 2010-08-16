class DropOlympifiedTables < ActiveRecord::Migration
  def self.up
    drop_table :fulfills
    drop_table :reactions
    drop_table :steps
    drop_table :definitions
    drop_table :recipients
    drop_table :organizations
    drop_table :roles
    drop_table :permissions
  end

  def self.down
    create_table "permissions", :force => true do |t|
      t.integer  "role_id"
      t.integer  "step_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "roles", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "definition_id"
    end
    
    create_table "organizations", :force => true do |t|
      t.string   "title"
      t.string   "url"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "recipients", :force => true do |t|
      t.integer  "step_id"
      t.integer  "organization_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "definitions", :force => true do |t|
      t.string   "title",      :null => false
      t.string   "name",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "steps", :force => true do |t|
      t.string   "title"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "start"
      t.string   "name",                         :null => false
      t.integer  "definition_id", :default => 1, :null => false
    end
    
    create_table "reactions", :force => true do |t|
      t.integer  "cause_id",   :null => false
      t.integer  "effect_id",  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    create_table "fulfills", :force => true do |t|
      t.integer  "organization_id"
      t.integer  "role_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
