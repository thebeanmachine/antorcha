require 'spec_helper'
require 'action_web_service/test_invoke'

describe MessageService, "soap service" do
  
  
  before(:each) do
    @controller = SoapController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def valid_token
    Api::Token.new(:username => 'aap', :password => 'noot')
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
    @example_messages ||= [Message.new(:title => 'aap'), Message.new(:title => 'noot')]
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
  it "should log in the user using the token"
  it "should use cancan to authorize these soap calls"

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
    
    it "should scrub the body if user is not permitted to :examine the message (maybe this should be done in Message#show)"
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
  end

end

