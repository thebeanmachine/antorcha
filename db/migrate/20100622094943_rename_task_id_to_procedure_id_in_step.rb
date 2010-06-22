class RenameTaskIdToProcedureIdInStep < ActiveRecord::Migration
  def self.up
    rename_column :steps, :task_id, :procedure_id
  end

  def self.down
    rename_column :steps, :procedure_id, :task_id
  end
end
