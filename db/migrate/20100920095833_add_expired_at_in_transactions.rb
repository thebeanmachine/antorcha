class AddExpiredAtInTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :expired_at, :datetime
  end

  def self.down
    remove_column :transactions, :expired_at
  end
end
