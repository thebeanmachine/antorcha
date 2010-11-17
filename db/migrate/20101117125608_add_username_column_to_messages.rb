class AddUsernameColumnToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :username, :string
  end

  def self.down
    remove_column :messages, :username
  end
end
