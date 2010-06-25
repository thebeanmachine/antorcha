require 'spec_helper'

describe TransactionCancellationJob do

  def stub_perform
    stub_find(mock_transaction)

    mock_transaction.stub \
      :messages => mock_messages,
      :uri => 'http://example.com/transaction/1',
      :stopped! => true,
      :cancelled? => true

    mock_messages.stub :outbox => mock_messages
    RestClient.stub :post => nil
  end

  subject { TransactionCancellationJob.new(mock_transaction.to_param)}

  describe "uncancelled transaction (can't happen, but anyways)" do
    def stub_perform_on_uncancelled_transaction
      stub_perform
      mock_transaction.stub :cancelled? => false, :stopped? => true
    end
    
    it "should not be stopped!" do
      stub_perform_on_uncancelled_transaction
      mock_transaction.should_not_receive :stopped!
      subject.perform
    end
  end

  describe "stopped transaction" do
    def stub_perform_on_stopped_transaction
      stub_perform
      mock_transaction.stub :stopped? => true
    end
    
    it "should not be stopped!" do
      stub_perform_on_stopped_transaction
      mock_transaction.should_not_receive :stopped!
      subject.perform
    end
  end

  describe "not stopped transaction" do
    def stub_perform_on_cancelled_transaction
      stub_perform
      mock_transaction.stub :stopped? => false
    end
    
    it "should be stopped!" do
      stub_perform_on_cancelled_transaction
      mock_transaction.should_receive :stopped!
      subject.perform
    end
    
    it "should post a cancellation request to localhost" do
      stub_perform_on_cancelled_transaction
      RestClient.should_receive(:post).with('http://localhost:3000/transactions/cancellations', anything).twice
      subject.perform
    end

    it "should post a cancellation request with the transaction uri" do
      stub_perform_on_cancelled_transaction
      RestClient.should_receive(:post).with(anything, hash_including(:transaction_uri => mock_transaction.uri)).twice
      subject.perform
    end
  end

end
