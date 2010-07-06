class DropDeliveredAtOfMessage < ActiveRecord::Migration
  def self.up
    remove_column :messages, :delivered_at
  end

  def self.down
    add_column :messages, :delivered_at, :datetime
  end
end
