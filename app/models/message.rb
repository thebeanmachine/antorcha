class Message < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :step

  belongs_to :step
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}
  
end
