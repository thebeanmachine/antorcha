require 'spec_helper'

describe MessagesHelper do


  describe "linking to cancellation of message transaction" do
    before(:each) do
      mock_message.stub :transaction => mock_transaction
      helper.stub :button_to_transaction_cancellation => "link"
    end
    
    it "should not link if message is cancelled" do
      mock_message.stub :cancellable? => false
      helper.button_to_message_transaction_cancellation(mock_message).should be_blank
    end

    it "should generate link if message is not cancelled" do
      mock_message.stub :cancellable? => true
      helper.button_to_message_transaction_cancellation(mock_message).should == "link"
    end
  end

end
