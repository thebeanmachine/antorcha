require 'spec_helper'

describe MessageDeliveriesController do
  include Devise::TestHelpers
  
  describe "POST create" do
    def post_create
      post :create, :message_id => mock_message.to_param
    end
    
    def stub_create
      stub_find(mock_message)
      mock_message.stub(:send_deliveries => nil)
      mock_message.stub(:cancelled? => false)
    end
    
    def stub_create_cancelled_message
      stub_find(mock_message)
      mock_message.stub(:cancelled? => true)
    end

    describe "as anonymous" do
      before(:each) do
        sign_in_user :registered
      end
      it "should redirect to the registered page'" do
        stub_create
        post_create
        response.should redirect_to('/registered.html')
      end
    end

    describe "as communicator" do
      before(:each) do
        sign_in_user :communicator
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
        flash[:notice].should =~ /Bericht is succesvol bij de uitgaande post terechtgekomen/
      end
      
      it "should not be possible to send a message when it's transaction was cancelled" do
        stub_create_cancelled_message
        post_create
        flash[:notice].should_not =~ /Bericht is succesvol bij de uitgaande post terechtgekomen/
        flash[:error].should =~ /Transactie is tussentijds geannuleerd, kan niet worden verzonden/
      end
      
    end
  end
  
end
