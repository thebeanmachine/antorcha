class AddTaskIdToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :task_id, :integer
  end

  def self.down
    remove_column :messages, :task_id
  end
end
