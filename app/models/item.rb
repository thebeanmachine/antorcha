class Item < ActiveRecord::Base  
  attr_accessible :description, :inbox_id, :inbox
  belongs_to :inbox
end
