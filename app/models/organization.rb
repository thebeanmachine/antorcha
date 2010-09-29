class Organization < Resource
  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :certificates

  def certificate
    certificates.first
  end

  def delivery_url
    url.gsub(%r[/messages], "/organizations/#{Organization.ourself!.id}/receptions")
  end

  def https?
    url =~ /^https:/
  end

  def delivery_confirmation_url delivery_id
    url.gsub(%r[/messages], "/organizations/#{Organization.ourself!.id}/deliveries/#{delivery_id}/confirmation")
  end

  def cancellation_url
    url.gsub(%r[/messages], "/transactions/cancellations")
  end
  
  def self.ourself!
    ourself
  end
  
  def self.ourself
    Identity.first!.organization
  end
end
