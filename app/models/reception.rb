
class Reception < ActiveRecord::Base
  include CertificateVerification
  include CrossAssociatedModel
  
  attr_protected :certificate, :content

  validates_presence_of :certificate, :content, :delivery_id, :organization_id
  validate_on_create :verified_organization_certificate?

  serialize :content
  belongs_to :message
  belongs_to_resource :organization
  
  # mini state machine
  after_save :receive, :if => :just_arrived?
  after_save :confirm, :if => :message_received_but_unconfirmed?

  flagstamp :confirmed

  def just_arrived?
    message.blank?
  end

  def message_received_but_unconfirmed?
    message and not confirmed?
  end

  def process
    self.message = Message.new
    message.from_hash(content)
    message.organization = organization
    if message.save
      save
    else
      raise "Message kon niet worden ontvangen: #{message.errors.full_messages}"
    end
  end

  #
  # Contract for the resource mixin
  #
  
  def https?
    organization.https?
  end
  
  def url
    organization.delivery_confirmation_url delivery_id
  end

private  
  def receive
    Delayed::Job.enqueue Jobs::ReceiveMessageJob.new(id)
  end

  def confirm
    Delayed::Job.enqueue Jobs::ConfirmReceptionJob.new(id)
  end

end
