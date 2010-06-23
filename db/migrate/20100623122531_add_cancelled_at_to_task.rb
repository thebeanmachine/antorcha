class AddCancelledAtToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :cancelled_at, :datetime
  end

  def self.down
    remove_column :tasks, :cancelled_at
  end
end
