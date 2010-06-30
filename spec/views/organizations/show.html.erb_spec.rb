require 'spec_helper'

describe "/organizations/show.html.erb" do
  include OrganizationsHelper
  before(:each) do
    assigns[:organization] = @organization = stub_model(Organization,
      :title => "value for title",
      :url => "value for url"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ url/)
  end
end
