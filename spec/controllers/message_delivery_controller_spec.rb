require 'spec_helper'

describe MessageDeliveryController do
  
  describe "POST create" do
    def post_create
      post :create, :message_id => mock_message.to_param
    end
    
    def stub_create
      stub_find(mock_message)
      stub_new_delivery_job
      mock_message.stub(:sent! => nil)
      Delayed::Job.stub(:enqueue => nil)
    end


    it "assigns the message to @message" do
      stub_create
      post_create
      assigns[:message].should == mock_message
    end

    it "flags the message as sent" do
      stub_create
      mock_message.should_receive(:sent!)
      post_create
    end
    
    it "enqueues a delivery job" do
      stub_create
      Delayed::Job.should_receive(:enqueue).with(mock_delivery_job)
      post_create
    end
    
    it "redirects to the message details" do
      stub_create
      post_create
      response.should redirect_to(message_url(mock_message))
    end

    it "flashes 'Bericht wordt verzonden'" do
      stub_create
      post_create
      flash[:notice].should =~ /Bericht wordt verzonden/
    end
  end
  
end
