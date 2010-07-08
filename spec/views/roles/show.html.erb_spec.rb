require 'spec_helper'

describe "/roles/show.html.erb" do
  include RolesHelper
  before(:each) do
    assigns[:role] = mock_role

    assigns[:definition] = mock_definition
    mock_role.stub :title => 'role title'
    mock_definition.stub :title => 'definition title'


    mock_role.stub :title => 'Role title'
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/Role title/)
  end
end
