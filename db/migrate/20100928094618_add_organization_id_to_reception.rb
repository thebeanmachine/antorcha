class AddOrganizationIdToReception < ActiveRecord::Migration
  def self.up
    add_column :receptions, :organization_id, :integer
  end

  def self.down
    remove_column :receptions, :organization_id
  end
end
