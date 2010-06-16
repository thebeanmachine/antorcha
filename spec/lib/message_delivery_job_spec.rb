require 'spec_helper'

describe MessageDeliveryJob do
  subject {
    MessageDeliveryJob.new(mock_message.to_param)
  }

  def stub_perform
    stub_find(mock_message)
    stub_rest_client_post
    mock_message.stub(:to_json => "JSON!")
  end

  def stub_rest_client_post
    RestClient.stub(:post => nil)
  end
  
  describe "how it performs" do
    it "should find the message" do
      stub_perform
      Message.should_receive(:find).with(mock_message.to_param)
      subject.perform
    end

    it "should post the message" do
      stub_perform
      RestClient.should_receive(:post)
      subject.perform
    end
    
    it "should post the message as json" do
      stub_perform
      RestClient.should_receive(:post).with(
        anything(), mock_message.to_json, hash_including(
          :content_type => :json, :accept => :json
        ))
      subject.perform
    end
    
    it "should post the message locally" do
      stub_perform
      RestClient.should_receive(:post).with('http://localhost:3000/messages', anything(), anything())
      subject.perform
    end
  end
end
