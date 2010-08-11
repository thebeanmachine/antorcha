class Delivery < ActiveRecord::Base
  include CrossAssociatedModel
  
  belongs_to :message
  belongs_to_resource :organization

  flagstamp :delivered
  
  after_save :deliver
  
  delegate :url, :to => :organization
  
  def deliver
    Delayed::Job.enqueue MessageDeliveryJob.new(id)
  end
end
