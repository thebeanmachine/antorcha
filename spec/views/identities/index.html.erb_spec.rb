require 'spec_helper'

describe "/identities/index.html.erb" do
  include IdentitiesHelper

  before(:each) do
    assigns[:identities] = [
      stub_model(Identity,
        :string => ,
        :string => ,
        :organization_id => 1
      ),
      stub_model(Identity,
        :string => ,
        :string => ,
        :organization_id => 1
      )
    ]
  end

  it "renders a list of identities" do
    render
    response.should have_tag("tr>td", .to_s, 2)
    response.should have_tag("tr>td", .to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
