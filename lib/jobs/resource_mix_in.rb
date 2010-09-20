
module Jobs
  module ResourceMixIn
    def resource model
      model.https? ? secured_resource(model.url) : plain_resource(model.url)
    end

    def secured_resource url
      RestClient::Resource.new url,
        :ssl_client_cert  =>  Identity.certificate.certificate,
        :ssl_client_key   =>  Identity.private_key,
        :ssl_ca_file      =>  File.join( Rails.root, 'certs', "the-bean-machine-ca.crt" ),
        :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
    end
  
    def plain_resource url
      RestClient::Resource.new(url)
    end
  end
end
