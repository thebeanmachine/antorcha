require 'spec_helper'

describe "/organizations/new.html.erb" do
  include OrganizationsHelper

  before(:each) do
    assigns[:organization] = stub_model(Organization,
      :new_record? => true,
      :title => "value for title",
      :url => "value for url"
    )
  end

  it "renders new organization form" do
    render

    response.should have_tag("form[action=?][method=post]", organizations_path) do
      with_tag("input#organization_title[name=?]", "organization[title]")
      with_tag("input#organization_url[name=?]", "organization[url]")
    end
  end
end
