class RenameTaskToTransaction < ActiveRecord::Migration
  def self.up
    rename_table :tasks, :transactions
    rename_column :messages, :task_id, :transaction_id
  end

  def self.down
    rename_column :messages, :transaction_id, :task_id
    rename_table :transactions, :tasks
  end
end
