class AddInboxIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :inbox_id, :integer
  end

  def self.down
    remove_column :items, :inbox_id
  end
end
