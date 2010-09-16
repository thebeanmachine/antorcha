require 'spec_helper'

describe DeliveriesController do
  include Devise::TestHelpers

  before(:each) do
    sign_in_user :maintainer
  end
  
  it "should get the undelivered or the queued deliveries" do
    queued_deliveries = mock_deliveries
    get :index
    assigns[:queued_deliveries] == queued_deliveries
  end

end
