require 'spec_helper'

describe NotificationsController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  #Delete these examples and add some real ones
  it "should use NotificationsController" do
    controller.should be_an_instance_of(NotificationsController)
  end

  describe "POST :create" do
    before(:each) do
      stub_find mock_notifier.as_null_object
    end
    
    it "should be successful" do
      post :create, :notifier_id => mock_notifier.to_param
      response.should be_redirect
    end

    it "should redirect to notifier" do
      post :create, :notifier_id => mock_notifier.to_param
      response.should redirect_to(notifier_url(mock_notifier))
    end

    it "should call #notify on @notifier" do
      mock_notifier.should_receive :queue_notification
      post :create, :notifier_id => mock_notifier.to_param
    end

  end
end
