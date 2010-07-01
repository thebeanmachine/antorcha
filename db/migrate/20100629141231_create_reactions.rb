class CreateReactions < ActiveRecord::Migration
  def self.up
    create_table :reactions do |t|
      t.integer :cause_id, :null => false
      t.integer :effect_id, :null => false

      t.timestamps
    end
    add_index :reactions, [:cause_id, :effect_id], :unique => true
  end

  def self.down
    remove_index :reactions, :column => [:cause_id, :effect_id]
    drop_table :reactions
  end
end
