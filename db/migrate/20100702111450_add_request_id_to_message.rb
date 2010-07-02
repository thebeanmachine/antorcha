class AddRequestIdToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :request_id, :integer
  end

  def self.down
    remove_column :messages, :request_id
  end
end
