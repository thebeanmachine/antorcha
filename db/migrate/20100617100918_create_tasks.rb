class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title, :null => false
      t.string :name, :null => false, :unique => true

      t.timestamps
    end
    
    add_column :steps, :task_id, :integer, :default => 1
    change_column :steps, :task_id, :integer, :null => false, :default => nil
  end

  def self.down
    remove_column :steps, :task_id
    drop_table :tasks
  end
end
