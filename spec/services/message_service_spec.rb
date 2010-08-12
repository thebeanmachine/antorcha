require 'spec_helper'
require 'action_web_service/test_invoke'

describe MessageService, "soap service" do
  
  
  before(:each) do
    @controller = SoapController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def example_messages
    @example_messages ||= [Message.new(:title => 'aap'), Message.new(:title => 'noot')]
  end
  
  def example_api_messages
    @example_api_messages ||= example_messages.map {|x| Api::Message.new(x)}
  end

  it "should list messages" do
    Message.stub(:all).and_return(example_messages)
    r = invoke_layered :message, :index
    r.should == example_api_messages
  end

  it "should list messages" do
    invoke_layered :message, :index
  end

end

