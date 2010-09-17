require 'spec_helper'

describe MessageDeliveryJob do
  subject {
    MessageDeliveryJob.new(mock_delivery.to_param)
  }

  def stub_perform
    stub_find(mock_delivery)
    stub_rest_client_post

    mock_delivery.stub \
      :message => mock_message,
      :url => 'http://example.com/messages',
      :delivered! => nil

    mock_message.stub \
      :to_xml => "XML!"
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

  def stub_rest_client_post
    RestClient::Resource.stub :new => mock_resource
    mock_resource.stub :post => nil
  end
  
  
  describe "without an identity" do
    before(:each) do
      mock_delivery.stub :https? => true
    end
    it "should raise an exception" do
      mock_delivery.stub :delivered? => false
      stub_perform
      lambda { subject.perform }.should raise_exception('No identity')
    end
  end
  
  shared_examples_for "undelivered message" do
    def stub_undelivered
      mock_delivery.stub :delivered? => false
      stub_perform
      stub_identity
    end
    
    it "should find the delivery" do
      stub_undelivered
      Delivery.should_receive(:find).with(mock_delivery.to_param).and_return(mock_delivery)
      subject.perform
    end

    it "should flag the delivery as delivered" do
      stub_undelivered
      mock_delivery.should_receive(:delivered!)
      subject.perform
    end

    it "should post the message" do
      stub_undelivered
      mock_resource.should_receive(:post)
      subject.perform
    end
    
    it "should post the message as xml" do
      stub_undelivered
      mock_resource.should_receive(:post).with(
        mock_message.to_xml, hash_including(
          :content_type => :xml, :accept => :xml
        ))
      subject.perform
    end
    
    it "should fetch destination url from the delivery (is delegated to organization)" do
      stub_undelivered
      mock_delivery.should_receive(:url).once
      subject.perform
    end
  end

  describe "https" do
    before(:each) do
      mock_delivery.stub :https? => true
    end
    it_should_behave_like "undelivered message"

    it "should post the message to the destination url of organizations" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with('http://example.com/messages', anything())
      subject.perform
    end

    it "should configure ssl verify to verify peer" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:verify_ssl => OpenSSL::SSL::VERIFY_PEER))
      subject.perform
    end

    it "should send the client certificate" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_client_cert => :certificate))
      subject.perform
    end

    it "should configure the client private key" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_client_key => :private_key))
      subject.perform
    end

    it "should configure the certificate authority" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with(anything(), hash_including(:ssl_ca_file => anything()))
      subject.perform
    end
  end
  
  describe "http" do
    before(:each) do
      mock_delivery.stub :https? => false
    end
    it_should_behave_like "undelivered message"
    
    it "should post the message to the destination url of organizations" do
      stub_undelivered
      RestClient::Resource.should_receive(:new).with('http://example.com/messages')
      subject.perform
    end
  end


  describe "a delivered message" do
    def stub_undelivered
      mock_delivery.stub :delivered? => true
      stub_perform
      stub_identity
    end
    
    it "should check if the delivery was delivered" do
      stub_undelivered
      mock_delivery.should_receive(:delivered?)
      subject.perform
    end
    
    it "should not flag the delivery as delivered" do
      stub_undelivered
      mock_delivery.should_not_receive(:delivered!)
      subject.perform
    end

    it "should not deliver the message" do
      stub_undelivered
      RestClient.should_not_receive(:post)
      subject.perform
    end

  end
  
end
