class Message < ActiveRecord::Base
  validates_presence_of :title
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}
end
