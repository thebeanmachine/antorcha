require 'message_serialization'

class Message < ActiveRecord::Base
  include MessageSerialization

  validates_presence_of :title, :on => :update
  validates_presence_of :step
  validates_presence_of :transaction

  validates_presence_of :sent_at, :if => :delivered?

  belongs_to :transaction
  belongs_to :step

  flagstamp :sent, :shown
  antonym :outgoing => :incoming

  belongs_to :request, :class_name => 'Message'
  has_many :replies, :class_name => 'Message', :foreign_key => 'request_id'

  has_many :deliveries
  has_many :delivery_organizations, :through => :deliveries, :source => :organization

  default_scope :order => 'messages.created_at DESC'
  
  named_scope :inbox, :conditions => {:incoming => true}
  named_scope :outbox, :conditions => {:incoming => false}
  named_scope :with_definition, lambda{|definition| {:joins => :step, :conditions => { :steps => {:definition_id => definition}}} }
  
  delegate :definition, :to => :step
  delegate :destination_url, :to => :step

  after_create :format_title
  before_validation :take_over_transaction_from_request

  #
  # should get more complex, add role filter here.
  #
  def effect_steps
    step.effects
  end
  
  delegate :destination_organizations, :to => :step

  def status
    status ||= :incoming if incoming?
    status ||= delivered?
    status ||= sent?
    status ||= :draft
    status
  end

  def delivered_at
    delivered_at = deliveries.maximum :delivered_at
    delivered_at.in_time_zone if delivered_at
  end

  def delivered?
    :delivered unless deliveries.count == 0 or deliveries.exists? :delivered_at => nil
  end

  # YOU CAN'T OVERRIDE send
  def send_deliveries
    # OW YEAH!
    delivery_organizations << destination_organizations
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

