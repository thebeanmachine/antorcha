class RenameStepIdToInstructionIdInMessage < ActiveRecord::Migration
  def self.up
    rename_column :messages, :step_id, :instruction_id
  end

  def self.down
    rename_column :messages, :instruction_id, :step_id
  end
end
