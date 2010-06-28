class AddDestinationUrlToStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :destination_url, :string, :default => 'http://localhost:3000/messages'
  end

  def self.down
    remove_column :steps, :destination_url
  end
end
