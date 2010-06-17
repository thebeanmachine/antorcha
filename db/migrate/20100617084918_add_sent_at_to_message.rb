class AddSentAtToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :sent_at, :datetime
  end

  def self.down
    remove_column :messages, :sent_at
  end
end
