class AddStartToStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :start, :boolean
  end

  def self.down
    remove_column :steps, :start
  end
end
