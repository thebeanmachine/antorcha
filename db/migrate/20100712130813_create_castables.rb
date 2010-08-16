class CreateCastables < ActiveRecord::Migration
  def self.up
    create_table :castables do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
  end

  def self.down
    drop_table :castables
  end
end
