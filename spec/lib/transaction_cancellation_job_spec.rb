require 'spec_helper'

describe TransactionCancellationJob do


  subject { TransactionCancellationJob.new(mock_transaction.to_param)}

  it "performs" do
    stub_find(mock_transaction)
    mock_transaction.stub :messages => mock_messages, :uri => 'http://example.com/transaction/1'
    mock_messages.stub :outbox => mock_messages
    
    RestClient.stub(:post => nil)
    
    subject.perform
  end
end
