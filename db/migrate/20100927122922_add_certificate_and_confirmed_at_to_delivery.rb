class AddCertificateAndConfirmedAtToDelivery < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :confirmed_at, :datetime
    add_column :deliveries, :certificate, :text
  end

  def self.down
    remove_column :deliveries, :certificate
    remove_column :deliveries, :confirmed_at
  end
end
