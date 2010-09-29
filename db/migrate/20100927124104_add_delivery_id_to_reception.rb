class AddDeliveryIdToReception < ActiveRecord::Migration
  def self.up
    add_column :receptions, :delivery_id, :integer
  end

  def self.down
    remove_column :receptions, :delivery_id
  end
end
