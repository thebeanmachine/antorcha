require 'spec_helper'
require 'action_web_service/test_invoke'
require 'devise/test_helpers'

describe MessageService, "soap service" do
  
  def stub_can what, where = anything()
    @service.stub(:can?).with(what, where).and_return(false)
  end

  def stub_cannot what, where = anything()
    @service.stub(:can?).with(what, where).and_return(false)
  end

  
  before(:each) do
    stub_authenticated_soap_service

    @service = MessageService.new @controller
    MessageService.stub :new => @service
    
    @service.stub :authorize! => nil
    @service.stub :can? => true
    
    mock_user.stub :username => 'piet'
    mock_step.stub :xsd => nil
    
    stub_out_user_step_selection_validation
    mock_transaction.stub(:cancelled? => true, :expired? => true)
    
  end

  def stub_out_user_step_selection_validation
    Step.stub :starting_steps => [mock_step]
  end

  def valid_token
    Api::Token.new(:username => 'aap', :password => 'nootjes')
  end

  def invalid_token
    Api::Token.new(:username => 'noot', :password => 'mies')
  end

  def example_message
    @example_message ||= Message.create!(:title => 'aap', :body => 'mies', :user => mock_user, :step => mock_step, :transaction => mock_transaction)
  end

  def example_api_message
    @example_api_message ||= Api::Message.new(example_message)
  end

  def example_messages
    @example_messages ||= [Message.new(:title => 'aap', :body => 'mies', :user => mock_user, :step => mock_step, :transaction => mock_transaction), Message.new(:title => 'noot', :body => 'bok', :step => mock_step, :transaction => mock_transaction)]
  end
  
  def example_inbox_messages
    [Message.new(:title => 'aap', :body => 'mies', :username => "henk", :incoming => true), Message.new(:title => 'aap', :body => 'mies', :username => "henk", :incoming => true)]
  end
  
  def example_outbox_messages
    [Message.new(:username => "henk", :title => 'aap', :body => 'mies', :incoming => false), Message.new(:username => "henk", :title => 'aap', :body => 'mies', :incoming => false)]
  end  
  
  def example_unread_messages
    [Message.new(:username => "henk", :title => 'aap', :body => 'mies', :shown_at => nil), Message.new(:username => "henk", :title => 'aap', :body => 'mies', :shown_at => nil)]
  end
  
  def example_expired_messages
    [Message.new(:username => "henk", :title => 'aap', :body => 'mies', :transaction => mock_transaction)]
  end
  
  def example_cancelled_messages
    [Message.new(:username => "henk", :title => 'aap', :body => 'mies', :transaction => mock_transaction)]
  end
  
  def example_read_messages
    [Message.new(:username => "henk", :title => 'aap', :body => 'mies', :shown_at => !nil), Message.new(:username => "henk", :title => 'aap', :body => 'mies', :shown_at => !nil)]
  end
  
  def example_api_messages
    example_messages.map {|x| Api::Message.new(x)}
  end
  
  def example_api_unread_messages
    example_unread_messages.map {|x| Api::Message.new(x)}
  end
  
  def example_api_read_messages
    example_read_messages.map {|x| Api::Message.new(x)}
  end
  
  def example_api_inbox_messages
    example_inbox_messages.map {|x| Api::Message.new(x)}
  end
  
  def example_api_outbox_messages
    example_outbox_messages.map {|x| Api::Message.new(x)}
  end
  
  def raise_dispatch_error match = nil
    raise_error ActionWebService::Dispatcher::DispatcherError, match
  end

  def deny_access
    raise_dispatch_error(/Access denied/)
  end

  describe "listing messages with different scopes" do
    def stub_named_scope scope
      Message.stub(scope).and_return(example_messages)
    end

    it "should return all messages of api messages" do
      stub_named_scope :all
      r = invoke_layered :message, :index, valid_token
      r.should == example_api_messages
    end
    
    it "should return the unread messages of api messages" do
      stub_named_scope :unread
      r = invoke_layered :message, :index_unread, valid_token
      r.should == example_api_messages
    end
    
    it "should return the read messages of api messages" do
      stub_named_scope :read
      r = invoke_layered :message, :index_read, valid_token
      r.should == example_api_messages
    end
    
    it "should return the inbox messages of api messages" do
      stub_named_scope :inbox
      r = invoke_layered :message, :index_inbox, valid_token
      r.should == example_api_messages
    end
    
    it "should return the outbox messages of api messages" do
      stub_named_scope :outbox
      r = invoke_layered :message, :index_outbox, valid_token
      r.should == example_api_messages
    end

    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :message, :index, invalid_token }.should deny_access
    end
    
    it "should scrub the body if user is not permitted to :examine any message" do
      stub_named_scope :all
      stub_cannot :examine
      r = invoke_layered :message, :index, valid_token
      r.collect(&:body).should == [nil,nil]
    end
  end

  describe "showing a message" do
    before(:each) do
      Message.stub(:show).with(37).and_return(example_message)
    end

    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :message, :show, invalid_token, nil }.should deny_access
    end

    it "should show a message by invoking :show on the Message model" do
      Message.should_receive(:show)
      r = invoke_layered :message, :show, valid_token, 37
    end

    it "should show return the correct api message" do
      r = invoke_layered :message, :show, valid_token, 37
      r.should == example_api_message
    end
    
    it "should scrub the body if user is not permitted to :examine the message" do
      stub_cannot :examine, example_message
      r = invoke_layered :message, :show, valid_token, 37
      r.body.should == nil
    end
  end
  
  describe "reply to a message" do
    it "should create a new reply-message" do
      Message.stub(:find).with(example_message.id).and_return(example_message)      
      reply_example_message = Message.new(:request_id => example_message.id)      
      replies = example_message.stub(:replies).and_return([])
      replies.stub(:create).and_return(reply_example_message)
      reply_example_message.request_id.should == example_message.id
    end
  end
  
  describe "updating a message" do
    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :message, :update, invalid_token, nil }.should deny_access
    end
    
    it "should save the body and title of the supplied message" do
      Message.stub(:find).with(example_message.id).and_return(example_message)

      updated_message =  Api::Message.new(example_message)
      updated_message.title = "new title"
      updated_message.body = "new body"

      m = invoke_layered :message, :update, valid_token, updated_message

      m.title.should == 'new title'
      m.body.should == 'new body'
    end
    
    it "should check if it can update this message" do
      Message.stub(:find).with(example_message.id).and_return(example_message)
      @service.should_receive(:authorize!).with(:update, example_message).and_return(true)
      invoke_layered :message, :update, valid_token, example_api_message
    end
  end

  describe "sending (delivering) a message" do
    before(:each) do
      example_message.stub :send_deliveries => nil
    end
    
    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :message, :deliver, invalid_token, nil }.should deny_access
    end
    
    it "should send deliveries" do
      Message.stub(:find).with(example_message.id).and_return(example_message)
      example_message.should_receive(:send_deliveries).and_return(nil)
      invoke_layered :message, :deliver, valid_token, example_api_message
    end
    
    it "should check if it can send this message" do
      Message.stub(:find).with(example_message.id).and_return(example_message)
      @service.should_receive(:authorize!).with(:send, example_message).and_return(true)
      invoke_layered :message, :deliver, valid_token, example_api_message
    end
  end

  describe "initiating a transaction and sending (delivering) a message" do
    before(:each) do
      example_message.stub :send_deliveries => nil
      stub_find_step
      stub_step_definition
      stub_already_specced_mixin_create_transaction_and_message
    end
    
    def stub_find_step
      Step.stub(:find).with(mock_step.id).and_return(mock_step)
    end
    
    def stub_step_definition
      mock_step.stub :definition => mock_definition
    end
    
    def stub_already_specced_mixin_create_transaction_and_message
      @service.stub :create_transaction_and_message => example_message
    end
    
    it "should not be permitted with an invalid token" do
      invoke_layered :message, :deliver_message_after_init_transaction, valid_token, Api::Step.new(:id => mock_step.id), nil, nil 
    end

    it "should send deliveries" do
      example_message.should_receive(:send_deliveries).and_return(nil)
      invoke_layered :message, :deliver_message_after_init_transaction, valid_token,  Api::Step.new(:id => mock_step.id), 'title', 'body'
    end

  end

  it "should delete a message" do
    mock_transaction.stub(:expired?).and_return(true)
    
    Message.stub(:find).with(example_message.id).and_return(example_message)
    invoke_layered :message, :delete, valid_token, example_api_message
  end

end

