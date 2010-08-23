class Delivery < ActiveRecord::Base
  include CrossAssociatedModel
  
  belongs_to :message
  belongs_to_resource :organization

  flagstamp :delivered
  
  after_save :deliver
  
  def url
    organization.delivery_url
  end
  
  def deliver
    Delayed::Job.enqueue MessageDeliveryJob.new(id)
  end
end
