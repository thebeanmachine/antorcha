require 'spec_helper'

describe Jobs::ResourceMixIn do
  class ExampleJob < Struct.new(:model)
    include Jobs::ResourceMixIn
    
    def perform
      resource(model)
    end
  end

  def stub_identity
    Identity.stub \
      :certificate => mock_certificate,
      :private_key => :private_key
      
    mock_certificate.stub :certificate => :certificate
  end

  def mock_resource
    @mock_resource ||= mock(RestClient::Resource)
  end

  before(:each) do
    stub_identity
    mock_delivery.stub :url => 'http://example.com/messages'
    RestClient::Resource.stub :new => mock_resource
  end
  
  subject { ExampleJob.new mock_delivery }
  
  describe "https" do
    before(:each) do
      mock_delivery.stub :https? => true
    end

    it "should post the message to the destination url of organizations" do
      RestClient::Resource.should_receive(:new).with('http://example.com/messages', anything())
      subject.perform
    end

    it "should configure ssl verify to verify peer" do
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:verify_ssl => OpenSSL::SSL::VERIFY_PEER))
      subject.perform
    end

    it "should send the client certificate" do
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_client_cert => :certificate))
      subject.perform
    end

    it "should configure the client private key" do
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_client_key => :private_key))
      subject.perform
    end

    it "should configure the certificate authority" do
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_ca_file => anything()))
      subject.perform
    end
    
    it "should fetch destination url from the delivery (is delegated to organization)" do
      mock_delivery.should_receive(:url).once
      subject.perform
    end
  end
  
  describe "http" do
    before(:each) do
      mock_delivery.stub :https? => false
    end
    
    it "should post the message to the destination url of organizations" do
      RestClient::Resource.should_receive(:new).with('http://example.com/messages')
      subject.perform
    end
    
    it "should fetch destination url from the delivery (is delegated to organization)" do
      mock_delivery.should_receive(:url).once
      subject.perform
    end
  end
end
