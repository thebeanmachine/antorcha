class DropDestinationUrlInStep < ActiveRecord::Migration
  def self.up
    remove_column :steps, :destination_url
  end

  def self.down
    add_column :steps, :destination_url, :string, :default => "http://localhost:3000/messages"
  end
end
