class CreateTasksAgain < ActiveRecord::Migration
  def self.up
    create_table :tasks, :force => true do |t|
      t.string :title, :null => false
      t.string :name, :null => false, :unique => true
      t.integer :procedure_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
