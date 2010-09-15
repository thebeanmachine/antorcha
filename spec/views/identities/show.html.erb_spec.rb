require 'spec_helper'

describe "/identities/show.html.erb" do
  include IdentitiesHelper
  before(:each) do
    assigns[:identity] = @identity = stub_model(Identity,
      :private_key => '',
      :pass_phrase => '',
      :organization_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(//)
    response.should have_text(//)
    response.should have_text(/1/)
  end
end
