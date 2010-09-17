class MessageDeliveryJob < Struct.new(:delivery_id)
  def perform
    @delivery = Delivery.find(delivery_id)
    @message = @delivery.message

    deliver
  end

  def deliver
    unless @delivery.delivered?
      send_message
      @delivery.delivered!
    end
  end

  def send_message
    resource.post @message.to_xml, :content_type => :xml, :accept => :xml
  end
  
  def resource
    @delivery.https? ? secured_resource : plain_resource
  end

  def secured_resource
    RestClient::Resource.new @delivery.url,
      :ssl_client_cert  =>  Identity.certificate.certificate,
      :ssl_client_key   =>  Identity.private_key,
      :ssl_ca_file      =>  File.join( Rails.root, 'certs', "the-bean-machine-ca.crt" ),
      :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
  end
  
  def plain_resource
    RestClient::Resource.new(@delivery.url)
  end
  
end
