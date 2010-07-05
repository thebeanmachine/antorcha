require 'spec_helper'

describe "/organizations/index.html.erb" do
  include OrganizationsHelper

  before(:each) do
    assigns[:organizations] = [
      stub_model(Organization,
        :title => "value for title",
        :url => "value for url"
      ),
      stub_model(Organization,
        :title => "value for title",
        :url => "value for url"
      )
    ]
    
    act_as :maintainer
  end

  it "renders a list of organizations" do
    render
    debunk response.body
    response.should have_tag("ul li a", "value for title".to_s, 2)
  end
end
