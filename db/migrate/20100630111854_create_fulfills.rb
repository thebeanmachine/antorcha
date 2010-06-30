class CreateFulfills < ActiveRecord::Migration
  def self.up
    create_table :fulfills do |t|
      t.integer :organization_id
      t.integer :transaction_role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fulfills
  end
end
