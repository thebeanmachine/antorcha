require 'spec_helper'

describe TransactionCancellationsController do
  describe "POST create" do
    
    def stub_create_action
      stub_find mock_transaction
      stub_find_by mock_transaction, :uri => 'http://example.com/transactions'

      mock_transaction.stub :cancelled! => nil

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
        mock_transaction.stub :cancelled? => true
      end
      
      it "should be idempotent" do
        stub_create_action
        post_create_with_uri
        mock_transaction.should_not_receive :cancelled!
      end
      it "should flash already cancelled" do
        stub_create_action
        post_create_with_uri
        flash[:notice].should =~ /Transaction was already cancelled/
      end
    end

    describe "uncancelled" do
      before(:each) do
        mock_transaction.stub :cancelled? => false
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

      it "should flag transaction as cancelled" do
        stub_create_action
        mock_transaction.should_receive(:cancelled!)
        post_create_with_id
      end

      it "should flash cancellation" do
        stub_create_action
        post_create_with_id
        flash[:notice].should =~ /Transaction was successfully cancelled/
      end
    
      it "should create a cancellation job to cascade cancellation over the network" do
        stub_create_action
        Delayed::Job.should_receive(:enqueue).with(mock_transaction_cancellation_job)
        post_create_with_id
      end
    end
  end
end
