require 'spec_helper'
require 'action_web_service/test_invoke'

describe StepService, "soap service" do
  
  before(:each) do
    stub_authenticated_soap_service
    
    @service = StepService.new @controller
    StepService.stub :new => @service

    @service.stub :authorize! => nil
  end

  def valid_token
    Api::Token.new(:username => 'aap', :password => 'nootjes')
  end

  def invalid_token
    Api::Token.new(:username => 'noot', :password => 'mies')
  end


  def example_steps
    @example_steps ||= [Step.new(:title => 'aap'), Step.new(:title => 'noot')]
  end
  
  def example_api_steps
    @example_api_steps ||= example_steps.map {|x| Api::Step.new(x)}
  end

  def example_message
    @example_message ||= Message.create!(:title => 'aap', :body => 'mies', :step => mock_step, :transaction => mock_transaction)
  end

  def example_api_message
    @example_api_message ||= Api::Message.new(example_message)
  end

  def raise_dispatch_error match = nil
    raise_error ActionWebService::Dispatcher::DispatcherError, match
  end
  
  def raise_transaction_service_error match = nil
    raise_error TransactionService::TransactionServiceError, match
  end

  def raise_record_not_found match = nil
    raise_error ActiveRecord::RecordNotFound 
  end

  def deny_access
    raise_dispatch_error(/Access denied/)
  end

  describe "get index of starting steps" do
    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :step, :starting_steps_index, invalid_token}.should deny_access
    end
    
    it "should list starting steps" do
      Step.stub :to_start_with => example_steps
      r = invoke_layered :step, :starting_steps_index, valid_token
      r.should == example_api_steps
    end
  end

  describe "get index of effect steps of a message" do
    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :step, :effect_steps_index, invalid_token, example_api_message}.should deny_access
    end
    
    it "should raise if message does not exist" do
      lambda {
        invoke_layered :step, :effect_steps_index, valid_token, Api::Message.new(:id => 42)
      }.should raise_record_not_found(/Couldn't find Message with ID=42/)
    end
    
    it "should list effect steps index of message" do
      Message.stub(:find).with(example_message.id).and_return(example_message)
      example_message.stub(:effect_steps).and_return(example_steps)
      r = invoke_layered :step, :effect_steps_index, valid_token, example_api_message
      r.should == example_api_steps
    end
  end


end

