class CreateCancellations < ActiveRecord::Migration
  def self.up
    create_table :cancellations do |t|
      t.references :transaction, :null => false
      t.references :organization, :null => false
      t.datetime :cancelled_at

      t.timestamps
    end
  end

  def self.down
    drop_table :cancellations
  end
end
