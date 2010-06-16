require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false,
      :step => mock_model(Step)
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
  
  describe "empty message" do
    subject { Message.create }
    
    specify { should have(1).error_on(:title) }
    specify { should have(1).error_on(:step) }
  end
  
  describe "delivery" do
    subject { Factory(:message) }

    it "can be delivered" do
      subject.delivered!
      subject.should be_delivered
    end

    it "should not be delivered by default" do
      subject.should_not be_delivered
    end

    it "should not be delivered twice" do
      yesterday = 1.day.ago
      subject.delivered_at = yesterday 
      subject.delivered!
      subject.delivered_at.to_i.should == yesterday.to_i
    end
  end
  
  describe "to xml" do
    subject { Factory(:message) }
    it "should work" do
      subject.to_xml
    end

    it "should serialize title" do
      subject.title = 'Aap noot mies'
      subject.to_xml.should =~ /<title>Aap noot mies<\/title>/
    end

    it "should serialize step" do
      subject.step = mock_step
      mock_step.stub(:name => 'aap-noot-mies')
      subject.to_xml.should =~ /<step>aap-noot-mies<\/step>/
    end
  end
  
  describe "from hash" do
    def stub_find_step_by_name
      Step.stub(:find_by_name).and_return(mock_step)
    end
    
    it "should find the step by name" do
      stub_find_step_by_name
      message = Message.new
      message.from_hash( :step => 'aap-noot-mies')
      message.step.should == mock_step
    end
    
    it "should return itself" do
      message = Message.new
      message.from_hash({}).should == message
    end
  end
  
end
