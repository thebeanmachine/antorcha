require 'spec_helper'
require 'action_web_service/test_invoke'

describe StepService, "soap service" do
  
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


  def example_steps
    @example_steps ||= [Step.new(:title => 'aap'), Step.new(:title => 'noot')]
  end
  
  def example_api_steps
    @example_api_steps ||= example_steps.map {|x| Api::Step.new(x)}
  end


  def raise_dispatch_error match = nil
    raise_error ActionWebService::Dispatcher::DispatcherError, match
  end
  
  def raise_transaction_service_error match = nil
    raise_error TransactionService::TransactionServiceError, match
  end

  def deny_access
    raise_dispatch_error(/Access denied/)
  end

  describe "get index of starting steps" do
    it "should not be permitted with an invalid token" do
      lambda { invoke_layered :step, :starting_step_index, invalid_token}.should deny_access
    end
    
    it "should list starting steps" do
      Step.stub :to_start_with => example_steps
      r = invoke_layered :step, :starting_step_index, valid_token
      r.should == example_api_steps
    end
  end

end

