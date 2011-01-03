class AddOrganizationTitleToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :organization_title, :string
  end

  def self.down
    remove_column :deliveries, :organization_title
  end
end