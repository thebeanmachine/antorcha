class CreateReceptions < ActiveRecord::Migration
  def self.up
    create_table :receptions do |t|
      t.text :certificate, :null => false
      t.text :content, :null => false
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :receptions
  end
end
