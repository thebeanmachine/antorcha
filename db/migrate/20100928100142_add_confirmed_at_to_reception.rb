class AddConfirmedAtToReception < ActiveRecord::Migration
  def self.up
    add_column :receptions, :confirmed_at, :datetime
  end

  def self.down
    remove_column :receptions, :confirmed_at
  end
end
