class AddUriToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :uri, :string
  end

  def self.down
    remove_column :transactions, :uri
  end
end
