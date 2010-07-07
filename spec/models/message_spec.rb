require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false,
      :step => mock_step,
      :transaction => mock_transaction
    }
  end

  describe "given valid attributes" do
    subject {Message.create(@valid_attributes)}
    it "should create a new instance" do
      subject.should have(:no).errors
    end
  end
  
  describe "accessibility" do
    it "incoming should not be accessible"
  end
  
  describe "delegation" do
    subject {Message.create!(@valid_attributes)}

    it "should user step to delegate definition" do
      mock_step.should_receive(:definition)
      subject.definition
    end
  end
  
  describe "creating a reply message" do
    it "takes over transaction from the request" do
      @request_message =  Message.create \
        :title => 'request message', :incoming => true,
        :step => mock_step, :transaction => mock_transaction

      @reply_message = Message.create \
        :title => 'reply message', :incoming => false,
        :step => mock_step, :request => @request_message
        
      @reply_message.transaction.should == mock_transaction
    end
    
    it "should know it's own effect steps" do
      message = Message.create!(@valid_attributes)
      mock_step.stub :effects => mock_steps
      message.effect_steps.should == mock_steps
    end
  end
  
  describe "empty message" do
    subject { Message.create }
    
    it "should not have a manditory title" do
      should have(:no).error_on(:title)
    end
    specify { should have(1).error_on(:step) }
    specify { should have(1).error_on(:transaction) }

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
    subject {
      m = Factory(:message)
      m.delivery_organizations << Factory(:organization)
      m
    }

    it "can be delivered" do
      subject.deliveries.first.delivered!
      subject.should be_delivered
    end

    it "has errors if message is delivered but not sent" do
      subject.deliveries.first.delivered!
      subject.should have(1).error_on(:sent_at)
    end

    it "should not be delivered by default" do
      subject.should_not be_delivered
    end

    it "status should be :delivered" do
      subject.deliveries.first.delivered!
      subject.status.should == :delivered
    end

    it "should not be delivered twice" do
      yesterday = 1.day.ago
      delivery = subject.deliveries.first
      delivery.delivered_at = yesterday 
      delivery.delivered!
      delivery.save
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
    def stub_from_hash
      stub_find_by mock_step, :name => 'aap-noot-mies'
    end
    
    def message_from_hash
      @message = Message.new
      @message.from_hash :step => 'aap-noot-mies', :transaction => 'http://example.com/transactions/1'
    end
    

    describe "with a unknown transaction" do
      def stub_unknown_transaction
        stub_from_hash
        stub_create mock_transaction
        stub_find_by nil, :uri => 'http://example.com/transactions/1', :on => Transaction
        mock_step.stub :definition => mock_definition
      end

      it "should create a transaction" do
        stub_unknown_transaction
        Transaction.should_receive :create
        message_from_hash
      end

      it "should create a transaction with the uri set" do
        stub_unknown_transaction
        Transaction.should_receive(:create).with(hash_including(:uri => 'http://example.com/transactions/1')).and_return(mock_transaction)
        message_from_hash
      end

      it "should create a transaction with the definition set" do
        stub_unknown_transaction
        Transaction.should_receive(:create).with(hash_including(:definition => mock_definition)).and_return(mock_transaction)
        message_from_hash
      end

      it "should assign this created transaction" do
        stub_unknown_transaction
        message_from_hash
        @message.transaction.should == mock_transaction
      end
    end
    
    describe "with a known transaction" do
      def stub_known_transaction
        stub_from_hash
        stub_find_by mock_transaction, :uri => 'http://example.com/transactions/1'
      end
      
      it "should find the step by name" do
        stub_known_transaction
        message_from_hash
        @message.step.should == mock_step
      end
      
      
      it "should not create a transaction" do
        stub_known_transaction
        Transaction.should_not_receive :create
        message_from_hash
      end

      it "should assign the found transaction" do
        stub_known_transaction
        message_from_hash
        @message.transaction.should == mock_transaction
      end
      
      it "should return itself" do
        stub_known_transaction
        @message = Message.new
        @message.from_hash(:step => 'aap-noot-mies', :transaction => 'http://example.com/transactions/1').should == @message
      end
    end
    

  end
  
end
