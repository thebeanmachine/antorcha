class RenameTransactionRoleToRole < ActiveRecord::Migration
  def self.up
    rename_table :transaction_roles, :roles
  end

  def self.down
    rename_table :roles, :transaction_roles
  end
end
