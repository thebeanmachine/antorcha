require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization

  validates_presence_of :title, :on => :update
  validates_presence_of :step
  validates_presence_of :transaction

  validates_presence_of :sent_at, :if => :delivered?

  belongs_to :transaction
  belongs_to :step
  flagstamp :sent, :delivered, :shown

  default_scope :order => 'messages.created_at DESC'
  
  named_scope :inbox, :conditions => {:incoming => true}
  named_scope :outbox, :conditions => {:incoming => false}
  
  delegate :definition, :to => :step
  delegate :destination_url, :to => :step

  after_create :format_title

  def status
    status ||= :incoming if incoming?
    status ||= delivered?
    status ||= sent?
    status ||= :draft
    status
  end
  
private
  def format_title
    update_attributes :title => "#{step.title} \##{id}" if title.blank?
  end

end

