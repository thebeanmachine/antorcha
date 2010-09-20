class Organization < Resource
  validates_presence_of :title
  validates_uniqueness_of :title

  has_many :certificates

  def certificate
    certificates.first
  end

  def delivery_url
    url.gsub(%r[/messages], "/receptions")
  end

  def https?
    url =~ /^https:/
  end

  def cancellation_url
    url.gsub(%r[/messages], "/transactions/cancellations")
  end
end
