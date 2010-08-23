require 'spec_helper'

describe Cancellation do
  before(:each) do
    @valid_attributes = {
      :transaction_id => 1,
      :organization_id => 1,
      :cancelled_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Cancellation.create!(@valid_attributes)
  end
end
