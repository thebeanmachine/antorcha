class AddIncomingBooleanForMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :incoming, :boolean, :default => false
  end

  def self.down
    remove_column :messages, :incoming
  end
end
