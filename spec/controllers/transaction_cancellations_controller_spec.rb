require 'spec_helper'

describe TransactionCancellationsController do
  describe "POST create" do
    
    def stub_create_action
      stub_find(mock_transaction)
      mock_transaction.stub(:cancelled! => nil)
    end
    
    def post_create
      post :create, :transaction_id => mock_transaction.to_param
    end
    
    it "should redirect to the transaction" do
      stub_create_action
      post_create
      response.should redirect_to(transaction_path(mock_transaction))
    end

    it "should flag transaction as cancelled" do
      stub_create_action
      mock_transaction.should_receive(:cancelled!)
      post_create
    end

    it "should flash cancellation" do
      stub_create_action
      post_create
      flash[:notice].should =~ /Transaction was successfully cancelled/
    end
    
    it "should create a cancellation job to cascade cancellation over the network"
  end
end
