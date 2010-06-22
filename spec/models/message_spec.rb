require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false,
      :instruction => mock_model(Instruction)
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
  
  describe "accessibility" do
    it "incomming should not be accessible"
    it "delivered_at should not be accessible"
  end
  
  describe "empty message" do
    subject { Message.create }
    
    specify { should have(1).error_on(:title) }
    specify { should have(1).error_on(:instruction) }
    
    it "status should be :draft" do
      subject.status.should == :draft
    end
  end
  
  describe "sending" do
    subject { Factory(:message) }

    it "can be send" do
      subject.sent!
      subject.should be_sent
    end
    
    it "should not be sent by default" do
      subject.should_not be_sent
    end
    
    it "status should be :sent" do
      subject.sent!
      subject.status.should == :sent
    end
    
    it "should not be sent twice" do
      yesterday = 1.day.ago
      subject.sent_at = yesterday 
      subject.sent!
      subject.sent_at.to_i.should == yesterday.to_i
    end
  end
  
  describe "delivery" do
    subject { Factory(:message) }

    it "can be delivered" do
      subject.delivered!
      subject.should be_delivered
    end

    it "has errors if message is delivered but not sent" do
      subject.delivered!
      subject.should have(1).error_on(:sent_at)
    end

    it "should not be delivered by default" do
      subject.should_not be_delivered
    end

    it "status should be :delivered" do
      subject.delivered!
      subject.status.should == :delivered
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

    it "should serialize instruction" do
      subject.instruction = mock_instruction
      mock_instruction.stub(:name => 'aap-noot-mies')
      subject.to_xml.should =~ /<instruction>aap-noot-mies<\/instruction>/
    end
  end
  
  describe "from hash" do
    def stub_find_instruction_by_name
      Instruction.stub(:find_by_name).and_return(mock_instruction)
    end
    
    it "should find the instruction by name" do
      stub_find_instruction_by_name
      message = Message.new
      message.from_hash( :instruction => 'aap-noot-mies')
      message.instruction.should == mock_instruction
    end
    
    it "should return itself" do
      message = Message.new
      message.from_hash({}).should == message
    end
  end
  
end
