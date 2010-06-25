class AddStoppedAtToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :stopped_at, :datetime
  end

  def self.down
    remove_column :transactions, :stopped_at
  end
end
