class Delivery < ActiveRecord::Base
  include CrossAssociatedModel
  include CertificateVerification
  
  belongs_to :message
  belongs_to_resource :organization

  flagstamp :delivered
  flagstamp :confirmed

  validate :verified_organization_certificate_on_confirmation
  
  before_create :set_organization_title
  after_create :deliver
  
  named_scope :queued, :conditions => {:confirmed_at => nil}
  
  cache_and_delegate :title, :to => :organization, :prefix => true, :allow_nil => true
  
  def verified_organization_certificate_on_confirmation
    verified_organization_certificate? if confirmed?
  end
  
  def url
    organization.delivery_url
  end
  
  def https?
    organization.https?
  end
  
  def deliver
    Delayed::Job.enqueue Jobs::MessageDeliveryJob.new(id)
  end
  
  def to_xml options = {}
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.delivery do
      xml.tag! :id, id
      xml.tag! :organization_id, organization_id
      message.to_xml :builder => xml, :skip_instruct => true
    end
  end
  
private
  def set_organization_title
    write_attribute :organization_title, organization.title if organization
  end
  
end
