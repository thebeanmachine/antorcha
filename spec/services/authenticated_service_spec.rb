require 'spec_helper'

describe AuthenticatedService do
  subject { AuthenticatedService.new mock_action_controller }
  
  def mock_action_controller
    @mock_action_controller ||= mock(ActionController)
  end
  
  describe "delegates methods to the controller instance" do
    it "should delegate :current_user to the controller, because transaction initiation mixin uses it to stamp a transaction with a user" do
      mock_action_controller.should_receive :current_user 
      subject.send :current_user
    end

    it "should delegate :can? to the controller, because services might authorize more actions" do
      mock_action_controller.should_receive(:can?).with(:aap, :noot)
      subject.send :can?, :aap, :noot
    end

    it "should delegate :url_for to the controller, because services use url_for to generate unique identifiers" do
      mock_action_controller.should_receive(:url_for).with(:aap, :noot)
      subject.send :url_for, :aap, :noot
    end
  end
end
