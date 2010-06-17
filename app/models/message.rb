require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization

  validates_presence_of :title
  validates_presence_of :step

  belongs_to :step
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}

  def delivered!
    update_attribute(:delivered_at, Time.now) unless delivered?
  end

  def delivered?
    not delivered_at.nil?
  end
end
