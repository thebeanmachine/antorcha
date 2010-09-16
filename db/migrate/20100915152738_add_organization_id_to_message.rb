class AddOrganizationIdToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :organization_id, :integer
  end

  def self.down
    remove_column :messages, :organization_id
  end
end
