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

  def stub_rest_client_post
    RestClient.stub(:post => nil)
  end
  
  describe "undelivered message" do
    def stub_undelivered
      mock_delivery.stub :delivered? => false
      stub_perform
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
      RestClient.should_receive(:post)
      subject.perform
    end
    
    it "should post the message as xml" do
      stub_undelivered
      RestClient.should_receive(:post).with(
        anything(), mock_message.to_xml, hash_including(
          :content_type => :xml, :accept => :xml
        ))
      subject.perform
    end
    
    it "should post the message to the destination url of organizations" do
      stub_undelivered
      RestClient.should_receive(:post).with('http://example.com/messages', anything(), anything()).once
      subject.perform
    end

    it "should fetch destination url from the delivery (is delegated to organization)" do
      stub_undelivered
      mock_delivery.should_receive(:url).once
      subject.perform
    end
  end
  
  describe "a delivered message" do
    def stub_undelivered
      mock_delivery.stub :delivered? => true
      stub_perform
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
