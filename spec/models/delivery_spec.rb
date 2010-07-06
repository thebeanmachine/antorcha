require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = {
      :message_id => 1,
      :organization_id => 1,
      :delivered_at => Time.now
    }

    stub_new_message_delivery_job
    Delayed::Job.stub(:enqueue => nil)
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end
  
  it "should enqueue a job to deliver the message" do
    Delayed::Job.should_receive(:enqueue).with(mock_message_delivery_job)
    Delivery.create!(@valid_attributes)
  end
end
