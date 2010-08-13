require 'spec_helper'
require 'action_web_service/test_invoke'

describe TransactionService, "soap service" do
  
  before(:each) do
    @controller = SoapController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    @service = TransactionService.new @controller
    TransactionService.stub :new => @service
  end

  def valid_token
    Api::Token.new(:username => 'aap', :password => 'noot')
  end

  def invalid_token
    Api::Token.new(:username => 'noot', :password => 'mies')
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

  describe "creating an initial transaction" do
    it "should fail on non existing step" do
      lambda { invoke_layered :transaction, :initiate, valid_token, Api::Step.new(:id => 37) }.should raise_transaction_service_error(/Step 37 not found/)
    end
    
    it "should create a transaction based on a step" do
      Step.stub(:find).with(37).and_return(mock_step)
      @service.stub :create_transaction_and_message => Message.new
      
      invoke_layered :transaction, :initiate, valid_token, Api::Step.new(:id => 37)
    end
  end

end

