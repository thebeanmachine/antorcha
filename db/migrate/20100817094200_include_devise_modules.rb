class IncludeDeviseModules < ActiveRecord::Migration
  def self.up
    drop_table :users if User.table_exists?    
    
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.validatable
      t.registerable
      t.activatable
      t.string :username, :null => false
      t.string :user_type, :default => 'registered', :null => false
      t.boolean :activated, :default => false
      # t.trackable
      # t.lockable

      t.timestamps
    end

    add_index :users, :username,                :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end

