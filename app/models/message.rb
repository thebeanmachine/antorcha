require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization

  validates_presence_of :title
  validates_presence_of :instruction

  validates_presence_of :sent_at, :if => :delivered?

  belongs_to :instruction
  flagstamp :sent, :delivered, :shown

  default_scope :order => 'messages.created_at DESC'
  
  named_scope :inbox, :conditions => {:incoming => true}
  named_scope :outbox, :conditions => {:incoming => false}

  def status
    status ||= :incoming if incoming?
    status ||= delivered?
    status ||= sent?
    status ||= :draft
    status
  end


end

