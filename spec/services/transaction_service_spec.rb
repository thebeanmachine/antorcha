require 'spec_helper'
require 'action_web_service/test_invoke'

describe TransactionService, "soap service" do
  
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


  def raise_dispatch_error match = nil
    raise_error ActionWebService::Dispatcher::DispatcherError, match
  end

  def deny_access
    raise_dispatch_error(/Access denied/)
  end

  describe "creating an initial transaction" do
    it "should return the list of api messages" do
      r = invoke_layered :transaction, :initiate, valid_token
      r.should == nil
    end
  end

end

