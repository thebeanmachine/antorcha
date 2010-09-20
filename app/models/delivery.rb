class Delivery < ActiveRecord::Base
  include CrossAssociatedModel
  
  belongs_to :message
  belongs_to_resource :organization

  flagstamp :delivered
  
  after_save :deliver
  
  named_scope :queued, :conditions => {:delivered_at => nil}
  
  def url
    organization.delivery_url
  end
  
  def https?
    organization.https?
  end
  
  def deliver
    Delayed::Job.enqueue Jobs::MessageDeliveryJob.new(id)
  end
end
