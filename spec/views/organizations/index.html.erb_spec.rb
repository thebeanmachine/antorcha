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
  end

  it "renders a list of organizations" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for url".to_s, 2)
  end
end
