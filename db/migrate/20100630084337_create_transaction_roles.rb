class CreateTransactionRoles < ActiveRecord::Migration
  def self.up
    create_table :transaction_roles do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :transaction_roles
  end
end
