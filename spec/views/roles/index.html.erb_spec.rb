require 'spec_helper'

describe "/roles/index.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:roles] = [
      stub_model(Role,
        :title => "value for title"
      ),
      stub_model(Role,
        :title => "value for title"
      )
    ]
  end

  it "renders a list of roles" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
