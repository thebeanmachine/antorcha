class AddNameToStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :name, :string
    execute "UPDATE steps SET name = 'step-' || id"
    change_column :steps, :name, :string, :null => false, :unique => true
  end

  def self.down
    remove_column :steps, :name
  end
end
