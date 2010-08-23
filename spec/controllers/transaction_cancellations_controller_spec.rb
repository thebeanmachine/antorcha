require 'spec_helper'

describe TransactionCancellationsController do
  
  it "should authenticate the other antorcha by oauth or other means."
  
  describe "POST create" do
    
    def stub_create_action
      sign_in_user
      
      stub_find mock_transaction
      stub_find_by mock_transaction, :uri => 'http://example.com/transactions'

      Delayed::Job.stub :enqueue => nil
      stub_new_transaction_cancellation_job
    end

    
    def post_create_with_id
      post :create, :transaction_id => mock_transaction.to_param
    end

    def post_create_with_uri
      post :create, :transaction_uri => mock_transaction.uri
    end

    it "does not verify authenticity token" do
      should_not have_before_filter(:verify_authenticity_token)
    end

    describe "cancellation on cancelled transaction" do
      before(:each) do
        mock_transaction.stub :cancel_and_cascade_cancellations => false
      end
      
      it "should flash already cancelled" do
        stub_create_action
        post_create_with_uri
        flash[:notice].should =~ /De transactie was al geannuleerd/
      end
    end

    describe "uncancelled" do
      before(:each) do
        mock_transaction.stub :cancel_and_cascade_cancellations => true
      end

      it "should find transaction by uri and redirect to it" do
        stub_create_action
        post_create_with_uri
        response.should redirect_to(transaction_path(mock_transaction))
      end
    
      it "should redirect to the transaction" do
        stub_create_action
        post_create_with_id
        response.should redirect_to(transaction_path(mock_transaction))
      end

      it "should flash cancellation" do
        stub_create_action
        post_create_with_id
        flash[:notice].should =~ /De transactie wordt geannuleerd/
      end
    
    end
  end
end
