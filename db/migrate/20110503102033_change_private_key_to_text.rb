class ChangePrivateKeyToText < ActiveRecord::Migration
  def self.up
    change_column :identities, :private_key, :text
  end

  def self.down
    change_column :identities, :private_key, :string
  end
end