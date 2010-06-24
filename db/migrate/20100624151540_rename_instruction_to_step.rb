class RenameInstructionToStep < ActiveRecord::Migration
  def self.up
    rename_table :instructions, :steps
    rename_column :messages, :instruction_id, :step_id
  end

  def self.down
    rename_column :messages, :step_id, :instruction_id
    rename_table :steps, :instructions
  end
end
