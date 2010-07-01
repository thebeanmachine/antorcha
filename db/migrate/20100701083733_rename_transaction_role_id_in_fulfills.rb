class RenameTransactionRoleIdInFulfills < ActiveRecord::Migration
  def self.up
    rename_column :fulfills,  :transaction_role_id, :role_id
  end

  def self.down
    rename_column :roles, :role_id, :transaction_role_id
  end
end
