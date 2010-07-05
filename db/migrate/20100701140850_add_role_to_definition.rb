class AddRoleToDefinition < ActiveRecord::Migration
  def self.up
    add_column :roles, :definition_id, :integer
  end

  def self.down
    remove_column :roles, :definition_id
  end
end
