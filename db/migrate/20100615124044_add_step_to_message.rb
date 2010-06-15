class AddStepToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :step_id, :integer
    execute "UPDATE messages SET step_id = (SELECT id FROM steps WHERE title='Hello world')"
    change_column :messages, :step_id, :integer, :null => false
  end

  def self.down
    remove_column :messages, :step_id
  end
end
