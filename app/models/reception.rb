
class Reception < ActiveRecord::Base
  attr_protected :certificate, :content

  validates_presence_of :certificate, :content
  serialize :content

  belongs_to :message
  
  after_save :receive

  def verify_organization_certificate
    return unless Rails.env.production?
    raise "not an registered certificate" unless verified_organization_certificate?
  end
  
private  
  def receive
    Delayed::Job.enqueue Jobs::ReceiveMessageJob.new(id)
  end
  
  def verified_organization_certificate?
    registered_certificate == received_certificate
  end

  def registered_certificate
    organization.certificate.certificate
  end

  def received_certificate
    OpenSSL::X509::Certificate.new(certificate)
  end

  def organization
    Organization.find(content[:organization_id])
  end

end

class OpenSSL::X509::Certificate
  def == c
    subject.eql? c.subject and
    public_key.to_s == c.public_key.to_s
  end
end
