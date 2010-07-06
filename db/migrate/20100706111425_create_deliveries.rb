class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.integer :message_id, :null => false
      t.integer :organization_id, :null => false
      t.datetime :delivered_at

      t.timestamps
    end
  end

  def self.down
    drop_table :deliveries
  end
end
