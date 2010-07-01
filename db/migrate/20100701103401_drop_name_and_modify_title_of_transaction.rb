class DropNameAndModifyTitleOfTransaction < ActiveRecord::Migration
  def self.up
    remove_index :transactions, :column => :name
    remove_column :transactions, :name
    change_column :transactions, :title, :string, :null => true
  end

  def self.down
    change_column :transactions, :title, :string, :null => false
    add_column :transactions, :name, :string
    add_index :transactions, :name, :unique => true
  end
end
