class Cancellation < ActiveRecord::Base
  include CrossAssociatedModel
  
  belongs_to :transaction
  belongs_to_resource :organization

  flagstamp :cancelled
  
  after_save :cancel
  
  def url
    organization.cancellation_url
  end
  
  def https?
    organization.https?
  end
  
  def cancel
    Delayed::Job.enqueue Jobs::TransactionCancellationJob.new(id)
  end
end
