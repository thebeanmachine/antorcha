class ChangeRoleReferenceToOrganizationInRecipients < ActiveRecord::Migration
  def self.up
    rename_column :recipients, :role_id, :organization_id
  end

  def self.down
    rename_column :recipients, :organization_id, :role_id
  end
end
