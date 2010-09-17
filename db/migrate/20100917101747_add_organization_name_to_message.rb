class AddOrganizationNameToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :organization_title, :string
  end

  def self.down
    remove_column :messages, :organization_title
  end
end
