require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization

  validates_presence_of :title
  validates_presence_of :step

  validates_presence_of :sent_at, :if => :delivered?

  belongs_to :step
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}

  
  def status
    status ||= :incoming if incoming?
    status ||= delivered?
    status ||= sent?
    status ||= :draft
    status
  end


  def send!
    update_attributes(:sent_at => Time.now) unless sent?
  end
  
  def sent?
    :sent if not sent_at.nil?
  end


  def delivered!
    update_attributes(:delivered_at => Time.now) unless delivered?
  end

  def delivered?
    :delivered if not delivered_at.nil?
  end
end
