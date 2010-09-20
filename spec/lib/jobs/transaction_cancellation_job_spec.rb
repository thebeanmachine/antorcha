require 'spec_helper'

describe Jobs::TransactionCancellationJob do

  before(:each) do
    resource_method_is_speced_in_resource_mixin_spec
  end

  def stub_perform
    stub_find(mock_cancellation)

    mock_cancellation.stub \
      :cancelled? => true,
      :transaction => mock_transaction,
      :url => 'http://example.com/cancellations',
      :cancelled! => true

    mock_transaction.stub :uri => 'http://example.com/transaction/uri'
    
    mock_resource.stub :post => nil
  end

  def mock_resource
    @mock_resource ||= mock(RestClient::Resource)
  end


  subject { Jobs::TransactionCancellationJob.new(mock_cancellation.to_param)}

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
    subject.should_receive(:resource).with(mock_cancellation).once
    subject.perform
  end

  it "should post a cancellation request with the transaction uri" do
    stub_perform_on_cancelled_transaction
    mock_resource.should_receive(:post).with(hash_including(:transaction_uri => mock_transaction.uri)).once
    subject.perform
  end


  def resource_method_is_speced_in_resource_mixin_spec
    subject.stub :resource => mock_resource
  end

end
