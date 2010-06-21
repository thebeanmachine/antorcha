class AddShownAtToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :shown_at, :datetime
  end

  def self.down
    remove_column :messages, :shown_at
  end
end
