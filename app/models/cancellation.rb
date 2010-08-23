class Cancellation < ActiveRecord::Base
  include CrossAssociatedModel
  
  belongs_to :transaction
  belongs_to_resource :organization

  flagstamp :cancelled
  
  after_save :cancel
  
  def url
    organization.cancellation_url
  end
  
  def cancel
    Delayed::Job.enqueue TransactionCancellationJob.new(id)
  end
end
