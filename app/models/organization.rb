class Organization < Resource
  validates_presence_of :title
  validates_uniqueness_of :title

  def delivery_url
    url
  end

  def cancellation_url
    url.gsub(%r[/messages], "/transactions/cancellations")
  end
end
