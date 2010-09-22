class AddInitializedAtToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :initialized_at, :datetime
  end

  def self.down
    remove_column :transactions, :initialized
  end
end
