require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization
  include CrossAssociatedModel

  validates_presence_of :title, :on => :update
  validates_presence_of :step
  validates_presence_of :transaction

  validates_presence_of :sent_at, :if => :delivered?

  belongs_to :transaction

  belongs_to_resource :step

  flagstamp :sent, :shown
  antonym :draft => :sent
  antonym :outgoing => :incoming
  
  belongs_to :request, :class_name => 'Message'
  has_many :replies, :class_name => 'Message', :foreign_key => 'request_id'

  has_many :deliveries
  #has_many :delivery_organizations, :through => :deliveries, :source => :organization

  default_scope :order => 'messages.created_at DESC'
  
  named_scope :inbox, :conditions => {:incoming => true}
  named_scope :outbox, :conditions => {:incoming => false}
  named_scope :read, :conditions => "shown_at is NOT NULL"
  named_scope :unread, :conditions => "shown_at is NULL"
  named_scope :with_definition, lambda{|definition| {:joins => :step, :conditions => { :steps => {:definition_id => definition}}} }
  named_scope :expired, lambda { {:joins => :transaction, :conditions => ["transactions.expired_at < ?", Time.now]} }
  named_scope :unexpired, lambda { {:joins => :transaction, :conditions => ["transactions.expired_at > ?", Time.now]} }
  named_scope :cancelled, lambda { {:joins => :transaction, :conditions => "transactions.cancelled_at is NOT NULL"} }
  
  delegate :definition, :to => :step
  delegate :destination_url, :to => :step

  delegate :cancelled?, :to => :transaction
  delegate :expired?, :to => :transaction  

  after_create :format_title
  before_validation :take_over_transaction_from_request
  
  def updatable?
    outgoing? and draft? and not cancelled?
  end
  
  def self.show message_id
    message = find(message_id)
    message.shown!
    message
  end
  
  def expired
    expired?
  end
  
  def unread
    shown_at.nil?
  end
  
  def cancelled
    cancelled? == :cancelled ? true : false
  end
  
  def replyable?
    incoming? and step.replyable? and not cancelled?
  end
  
  def cancellable?
    outgoing? and step.start? and not cancelled?
  end

  def effect_steps options = {}
    step.effects options
  end
  
  delegate :destination_organizations, :to => :step

  def status
    status ||= :incoming if incoming?
    status ||= delivered?
    status ||= sent?
    status ||= :draft
    status
  end

  # def statuses
  #   [ delivered?, expired?].compact
  # end

  def delivered_at
    delivered_at = deliveries.maximum :delivered_at
    delivered_at.in_time_zone if delivered_at
  end

  def delivered?
    :delivered unless deliveries.count == 0 or deliveries.exists? :delivered_at => nil
  end

  def send_deliveries
    destination_organizations.each do |org|
      deliveries << deliveries.build(:organization => org)
    end
    sent!
  end

private
  def format_title
    update_attributes :title => "#{step.title} \##{id}" if title.blank?
  end

  def take_over_transaction_from_request
    self.transaction = request.transaction if transaction.blank? and request
  end

end

