require 'spec_helper'

describe "/roles/index.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:definition] = mock_definition
    assigns[:roles] = mock_roles
    
    assigns[:definition] = mock_definition
    mock_definition.stub :title => 'definition title'
    
    
    mock_role.stub :title => 'Role title'
  end

  it "renders a list of roles" do
    render
    response.should have_tag("ul li a", "Role title".to_s, 2)
  end
end
