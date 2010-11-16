require 'spec_helper'

describe Notifier do
  before(:each) do

  end

  describe "blank" do
    subject { Notifier.new }
    specify { should have(1).error_on(:url) }
  end
  
  it "should create a new instance given valid attributes" do
    @valid_attributes = {
      :url => "http://example.com"
    }
    Notifier.create!(@valid_attributes)
  end
  
  describe "notification" do
    before(:each) do
      stub_new_send_notification_job
      Delayed::Job.stub :enqueue => nil
    end

    subject { Notifier.new :url => 'http://example.com' }
    specify { should respond_to(:queue_notification) }
    
    it "should enqueue the send_notification job" do
      Delayed::Job.should_receive(:enqueue).with(mock_send_notification_job)
      subject.queue_notification
    end
  end
  
  describe "notify all notifiers" do
    before(:each) do
      stub_all mock_notifiers
    end
    it "should queue notifications for each notifier" do
      mock_notifiers.each do |notifier|
        notifier.should_receive(:queue_notification)
      end
      Notifier.queue_all_notifications
    end
  end
end
