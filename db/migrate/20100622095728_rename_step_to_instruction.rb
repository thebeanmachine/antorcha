class RenameStepToInstruction < ActiveRecord::Migration
  def self.up
    rename_table :steps, :instructions
  end

  def self.down
    rename_table :instructions, :steps
  end
end
