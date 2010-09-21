require 'spec_helper'

describe ProcessingsController do
  include Devise::TestHelpers

  before(:each) do
    sign_in_user :maintainer
  end

  #Delete these examples and add some real ones
  it "should use ProcessingsController" do
    controller.should be_an_instance_of(ProcessingsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
