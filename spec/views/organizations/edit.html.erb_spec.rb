require 'spec_helper'

describe "/organizations/edit.html.erb" do
  include OrganizationsHelper

  before(:each) do
    assigns[:organization] = @organization = stub_model(Organization,
      :new_record? => false,
      :title => "value for title",
      :url => "value for url"
    )
  end

  it "renders the edit organization form" do
    render

    response.should have_tag("form[action=#{organization_path(@organization)}][method=post]") do
      with_tag('input#organization_title[name=?]', "organization[title]")
      with_tag('input#organization_url[name=?]', "organization[url]")
    end
  end
end
