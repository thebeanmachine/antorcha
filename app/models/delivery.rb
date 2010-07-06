class Delivery < ActiveRecord::Base
  belongs_to :message
  belongs_to :organization

  flagstamp :delivered
  
  after_save :deliver
  
  delegate :url, :to => :organization
  
  def deliver
    Delayed::Job.enqueue MessageDeliveryJob.new(id)
  end
end
