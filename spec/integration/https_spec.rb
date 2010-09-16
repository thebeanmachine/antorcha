require 'spec_helper'

describe RestClient, "client certificates" do

  it "should be able to connect to a https server using a client certificate" do
    pending "https is not configured yet on the bean machine server."
    
    RestClient::Resource.new(
      'https://thebeanmachine.nl/',
      :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read("/Users/daan/Projecten/Antorcha/https/thebeanmachine-daan.crt")),
      :ssl_client_key   =>  OpenSSL::PKey::RSA.new(File.read("/Users/daan/Projecten/Antorcha/https/thebeanmachine-daan.key"), "the bean machine"),
      :ssl_ca_file      =>  "/Users/daan/Projecten/Antorcha/https/thebeanmachine-ca.crt",
      :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER
    ).get
  end
end
