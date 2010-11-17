require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false,
      :step => mock_step,
      :username => "henk",
      :transaction => mock_transaction
    }
  end

  def example_message
    @example_message ||= Message.create \
      :title => "Dit is de message titel",
      :body => "Dit is de message body",
      :username => "henk",
      :step => mock_step,
      :transaction => mock_transaction
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
  
  describe "named scopes" do
    it "should include a filter by step"
  end
  
  describe ".user_id" do
    before(:each) do
      @message = example_message
      
      stub_find mock_user
      mock_user.stub :role_ids => [2,5]
    end
    
    it "includes messages with the recipient role steps" do
      Step.stub(:find_ids_by_recipient_role_ids).with([2,5]).and_return([mock_step.id, 6])

      Message.user_id(mock_user.to_param).all.should include(@message)
    end

    it "excludes messages without the recipient role steps" do
      Step.stub(:find_ids_by_recipient_role_ids).with([2,5]).and_return([5, 6])

      Message.user_id(mock_user.to_param).all.should_not include(@message)
    end
  end
  
  
  describe "delegation" do
    subject {Message.create!(@valid_attributes)}

    it "should user step to delegate definition" do
      mock_step.should_receive(:definition)
      subject.definition
    end
  end
  
  describe "when a message is updatable" do
    def example_outgoing_draft_message_with_an_active_transaction
      mock_step.stub :title => 'my step'
      mock_transaction.stub :cancelled? => false
      Message.new :transaction => mock_transaction, :step => mock_step, :outgoing => true
    end
    
    subject { example_outgoing_draft_message_with_an_active_transaction }
    
    specify { should be_updatable }
    
    it "should not be updatable if it's not an outgoing message" do
      subject.outgoing = false
      should_not be_updatable
    end

    it "should not be updatable if it's not an drafted message (has been sent)" do
      subject.sent!
      should_not be_updatable
    end

    it "should not be updatable if it's transaction is cancelled?" do
      subject.stub :cancelled? => true
      should_not be_updatable
    end
  end
  
  describe "when a transaction of a message can be cancelled" do
    subject do
      mock_step.stub :start? => true
      mock_transaction.stub :cancelled? => false
      Message.new :transaction => mock_transaction, :step => mock_step, :outgoing => true
    end
    
    specify { should be_cancellable }
    
    it "should not be cancellable if step is not a starting step" do
      subject.step = mock_step(:not_a_starting_step).tap {|m| m.stub :start? => false}
      should_not be_cancellable
    end

    it "should not be cancellable if it is an incoming message" do
      subject.incoming = true
      should_not be_cancellable
    end

    it "should not be cancellable if it's transaction is cancelled" do
      subject.transaction = mock_transaction(:cancelled_transaction).tap {|m| m.stub :cancelled? => true}
      should_not be_cancellable
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
    subject { example_message }

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
      m = example_message
      m.deliveries.build :organization => mock_organization
      m
    }

    it "can be delivered if all deliveries are confirmed" do
      subject.deliveries.first.confirmed!
      subject.should be_delivered
    end

    it "has errors if message is delivered but not sent" do
      subject.deliveries.first.confirmed!
      subject.should have(1).error_on(:sent_at)
    end

    it "should not be delivered by default" do
      subject.should_not be_delivered
    end

    it "status should be :delivered" do
      subject.deliveries.first.confirmed!
      subject.status.should == :delivered
    end

    it "should not be delivered twice" do
      yesterday = 1.day.ago
      delivery = subject.deliveries.first
      delivery.confirmed_at = yesterday 
      delivery.confirmed!
      delivery.save
      subject.delivered_at.to_i.should == yesterday.to_i
    end
  end
  
  describe "to xml" do

    def stub_to_xml
      mock_transaction.stub \
        :uri => "http://example.com",
        :initialized_at => DateTime.now,
        :cancelled? => true, :expired? => true
      mock_step.stub :name => "dit is de naam van de stap"
    end

    before(:each) do
      stub_to_xml
    end

    subject {
      example_message
    }
    
    describe "for transport" do
      it "should work" do
        subject.to_xml
      end

      it "should serialize title" do
        subject.title = 'Aap noot mies'
        subject.to_xml.should =~ /<title>Aap noot mies<\/title>/
      end

      it "should serialize step" do
        subject.step = mock_step
        subject.to_xml.should =~ %r[<step_id>#{mock_step.to_param}</step_id>]
      end

      describe "without identity" do
        # organization dependency is removed from serialization.
        it "should not raise 'no identity'" do
          lambda { subject.to_xml }.should_not raise_error('No identity')
        end
      end

      describe "with identity" do
        before(:each) do
          Identity.stub :first! => mock_identity
          mock_identity.stub :organization => mock_organization
        end

        it "should not serialize organization" do
          subject.to_xml.should_not =~ %r[<organization_id>#{mock_organization.to_param}</organization_id>]
        end
      end
    end
    
    describe "for local rest interface" do
      subject {
        example_message.to_xml :local => true
      }
      it "has an id" do
        should =~ %r[<id>#{example_message.to_param}</id>]
      end
      it "has a body element" do
        should =~ %r[<body>.*</body>]
      end
    end

    describe "scrubbed local rest interface" do
      subject {
        example_message.to_xml :local => true, :scrub => true
      }
      it "has no body element" do
        should_not =~ %r[<body>.*</body>]
      end
    end
  end
  
  describe "from hash" do
    def stub_from_hash
      Step.stub(:find).with(mock_step.id).and_return(mock_step)
      Organization.stub(:find).with(mock_organization.id).and_return(mock_organization)
    end
    
    def message_from_hash
      @message = Message.new
      @message.from_hash :step_id => mock_step.to_param, :transaction => {
        :uri => 'http://example.com/transactions/1', :initialized_at => DateTime.now
      }, :organization_id => mock_organization.to_param
    end
    
    it "should assign the organization" do
      stub_from_hash
      stub_find_by mock_transaction, :uri => 'http://example.com/transactions/1'

      message_from_hash
      @message.organization.should == mock_organization
    end
    
    it "should set incoming to true, because from hash message are _always_ received" do
      stub_from_hash
      stub_find_by mock_transaction, :uri => 'http://example.com/transactions/1'

      message_from_hash
      @message.should be_incoming
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
        @message.from_hash(:step_id => mock_step.to_param, :transaction => { :uri =>  'http://example.com/transactions/1' }).should == @message
      end
    end
  end
  
end
