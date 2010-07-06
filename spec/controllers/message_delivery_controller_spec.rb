require 'spec_helper'

describe MessageDeliveriesController do
  
  describe "POST create" do
    def post_create
      post :create, :message_id => mock_message.to_param
    end
    
    def stub_create
      stub_find(mock_message)
      mock_message.stub(:send_deliveries => nil)
    end

    describe "as anonymous" do
      it "should flash 'access denied'" do
        stub_create
        post_create
        flash[:error].should =~ /You are not authorized to access this page/
      end
    end

    describe "as sender" do
      before(:each) do
        act_as :sender
      end
      
      it "assigns the message to @message" do
        stub_create
        post_create
        assigns[:message].should == mock_message
      end

      it "sends the deliveries!" do
        stub_create
        mock_message.should_receive(:send_deliveries)
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
        flash[:notice].should =~ /Message is being sent/
      end
    end
  end
  
end
