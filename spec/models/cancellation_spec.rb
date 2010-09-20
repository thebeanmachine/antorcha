require 'spec_helper'

describe Cancellation do
  before(:each) do
    @valid_attributes = {
      :transaction_id => 1,
      :organization => mock_organization,
      :cancelled_at => Time.now
    }
  end

  subject do
    Cancellation.new(@valid_attributes)
  end
  
  specify { should have(:no).errors }
  
  specify { should respond_to(:url) }
  specify { should respond_to(:https?) }
  
  it "should delegate https? to organization" do
    mock_organization.should_receive(:https?)
    subject.https?
  end

  it "should delegate url? to organization as cancellation_url" do
    mock_organization.should_receive(:cancellation_url)
    subject.url
  end
  
end
