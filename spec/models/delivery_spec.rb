require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = {
      :message_id => 1,
      :organization_id => 1,
      :delivered_at => Time.now,
      :organization_title => 'black water'
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
  
  it "should create an undelivered messages" do
    Delivery.create(@valid_attributes.merge!(:delivered_at => nil))    
  end

  describe "serialization" do
    
    before(:each) do
      mock_organization.stub(:title => 'black water')
    end
    
    subject do
      mock_message.stub :to_xml do |options|
        options[:builder].message do end
      end
      Delivery.create :message => mock_message, :organization => mock_organization
    end
    
    it "serializes to xml" do      
      subject.to_xml
    end
    
    it "passes builder option to message#to_xml" do
      mock_message.should_receive(:to_xml).with(hash_including(:builder => anything()))
      subject.to_xml
    end

    it "passes skip_instruct option to message#to_xml" do
      mock_message.should_receive(:to_xml).with(hash_including(:skip_instruct => true))
      subject.to_xml
    end

    it "adds the id of the delivery" do
      subject.to_xml.should =~ %r[<id>1</id>]
    end

    it "adds the organization id of the delivery" do
      subject.to_xml.should =~ %r[<organization_id>#{mock_organization.id}</organization_id>]
    end

  end
  
end
