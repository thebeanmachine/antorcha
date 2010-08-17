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
  end

  def valid_token
    Api::Token.new(:username => 'aap', :password => 'nootjes')
  end

  def invalid_token
    Api::Token.new(:username => 'noot', :password => 'mies')
  end

  def example_message
    @example_message ||= Message.create!(:title => 'aap', :body => 'mies', :step => mock_step, :transaction => mock_transaction)
  end

  def example_api_message
    @example_api_message ||= Api::Message.new(example_message)
  end

  def example_messages
    @example_messages ||= [Message.new(:title => 'aap', :body => 'mies'), Message.new(:title => 'noot', :body => 'bok')]
  end
  
  def example_api_messages
    @example_api_messages ||= example_messages.map {|x| Api::Message.new(x)}
  end
  
  def raise_dispatch_error match = nil
    raise_error ActionWebService::Dispatcher::DispatcherError, match
  end

  def deny_access
    raise_dispatch_error(/Access denied/)
  end
  
  it "should list the messages that are unread"
  it "should list the messages that already have been read"
  it "should list the messages that are in the inbox"
  it "should list the messages that are in the outbox"
  it "should delete a messages with a given message_id as argument"
  it "should deliver a message with a given message_id as argument"
  it "should reply to a message"

  describe "listing messages" do
    before(:each) do
      Message.stub(:all).and_return(example_messages)
    end

    it "should return the list of api messages" do
      r = invoke_layered :message, :index, valid_token
      r.should == example_api_messages
    end

    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :message, :index, invalid_token }.should deny_access
    end
    
    it "should scrub the body if user is not permitted to :examine any message" do
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


end

