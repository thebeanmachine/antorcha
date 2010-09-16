class MessageDeliveryJob < Struct.new(:delivery_id)
  def perform
    delivery = Delivery.find(delivery_id)
    message = delivery.message

    unless delivery.delivered?
      RestClient::Resource.new(delivery.url,
        :ssl_client_cert  =>  Identity.certificate.certificate,
        :ssl_client_key   =>  Identity.private_key,
        :ssl_ca_file      =>  File.join( Rails.root, 'certs', "the-bean-machine-ca.crt" ),
        :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
      ).post message.to_xml, :content_type => :xml, :accept => :xml
      
      delivery.delivered!
    end
  end
end
