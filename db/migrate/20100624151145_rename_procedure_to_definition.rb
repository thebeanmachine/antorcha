class RenameProcedureToDefinition < ActiveRecord::Migration
  def self.up
    rename_table :procedures, :definitions
    rename_column :instructions, :procedure_id, :definition_id
    rename_column :transactions, :procedure_id, :definition_id
  end

  def self.down
    rename_column :transactions, :definition_id, :procedure_id
    rename_column :instructions, :definition_id, :procedure_id
    rename_table :definitions, :procedures
  end
end
