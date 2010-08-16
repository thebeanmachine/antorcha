class AddTypeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :string, :default => 'registered', :null => false
  end

  def self.down
    remove_column :users, :user_type
  end
end
