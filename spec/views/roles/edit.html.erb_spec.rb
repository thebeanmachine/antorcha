require 'spec_helper'

describe "/roles/edit.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:role] = mock_role
    assigns[:definition] = mock_definition
    mock_role.stub :title => 'role title'
    mock_definition.stub :title => 'definition title'
    stub_render_partial
  end

  it "renders the edit role form" do
    should_render_partial 'form'
    render
  end
end


