require 'spec_helper'

describe TransactionCancellationJob do

  def stub_perform
    stub_find(mock_cancellation)

    mock_cancellation.stub \
      :cancelled? => true,
      :transaction => mock_transaction,
      :url => 'http://example.com/cancellations',
      :cancelled! => true

    mock_transaction.stub :uri => 'http://example.com/transaction/uri'
    
    RestClient.stub :post => nil
  end

  subject { TransactionCancellationJob.new(mock_cancellation.to_param)}

  def stub_perform_on_cancelled_transaction
    stub_perform
    mock_transaction.stub :stopped? => false
  end
    
  it "should be stopped!" do
    stub_perform_on_cancelled_transaction
    mock_cancellation.should_receive :cancelled!
    subject.perform
  end
  
  it "should post a cancellation request to localhost" do
    stub_perform_on_cancelled_transaction
    RestClient.should_receive(:post).with('http://example.com/cancellations', anything).once
    subject.perform
  end

  it "should post a cancellation request with the transaction uri" do
    stub_perform_on_cancelled_transaction
    RestClient.should_receive(:post).with(anything, hash_including(:transaction_uri => mock_transaction.uri)).once
    subject.perform
  end

end
