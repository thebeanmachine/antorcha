class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.string :private_key
      t.string :passphrase
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :identities
  end
end
