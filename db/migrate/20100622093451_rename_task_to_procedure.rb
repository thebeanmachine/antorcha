class RenameTaskToProcedure < ActiveRecord::Migration
  def self.up
    rename_table :tasks, :procedures
  end

  def self.down
    rename_table :procedures, :tasks
  end
end
