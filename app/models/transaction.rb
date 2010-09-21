class Transaction < ActiveRecord::Base
  include CrossAssociatedModel
  
  validates_presence_of :title, :on => :update
  validates_presence_of :uri, :on => :update, :message => 'should have been assigned'
  validates_presence_of :definition


  default_scope :order => "transactions.created_at DESC"
  named_scope :with_organizations, lambda { |organization_ids| {
    :joins => {:messages => :deliveries}, 
    :conditions => {
      :messages => {
        :deliveries => {
          :organization_id => organization_ids
        }
      }
    }
  }}

  belongs_to_resource :definition
  has_many :messages
  has_many :deliveries, :through => :messages
  has_many :cancellations

  after_create :format_title
  after_create :expiration_date

  flagstamp :cancelled

  attr_accessor :starting_step
  
  named_scope :expired, lambda { {:conditions => ["expired_at < ?", Time.now]} }
 
  def validate_initiation
    errors.add_on_blank([:starting_step, :initialized_at])
  end

  def update_uri uri
    update_attributes :uri => uri
  end

  def stopped_at
    cancelled_at = cancellations.maximum :cancelled_at
    cancelled_at.in_time_zone if cancelled_at
  end

  def stopped?
    !(cancellations.count == 0 or cancellations.exists? :cancelled_at => nil)
  end
  
  def stopped
    stopped?
  end
  
  def expired
    expired?
  end
  
  def cancelled
    cancelled? == :cancelled ? true : false
  end

  def cancel_and_cascade_cancellations
    returning (not cancelled?) do |not_cancelled|
      cancel_and_cascade_cancellations_if_not_cancelled if not_cancelled
    end
  end
  
  def expired?
    Time.now > expired_at
  end

private
  def format_title
    update_attribute :title, "#{definition.title} \##{id}" if title.blank?
  end
  
  def expiration_date
    update_attribute :expired_at, (initialized_at + definition.expiration_days.days)
  end
  
  def cancel_and_cascade_cancellations_if_not_cancelled
    participating_organization_ids.each do |organization_id|
      cancellations << cancellations.build(:organization_id => organization_id)
    end
    
    cancelled!
  end

  def participating_organization_ids
    deliveries.collect(&:organization_id).uniq
  end

end
