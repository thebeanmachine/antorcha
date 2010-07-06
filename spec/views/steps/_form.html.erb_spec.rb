require 'spec_helper'

describe "/steps/_form.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:step] = mock_step
    assigns[:definition] = mock_definition
    
    mock_step.stub \
      :title => "value for title",
      :start => false,
      :errors => stub("errors").as_null_object,
      :destination_url => 'http://example.com/messages',
      :permission_role_ids => [],
      :recipient_role_ids => []

    mock_definition.stub :title => 'value for definition', :roles => mock_roles
  end

  it "renders the edit step form" do
    render

    response.should have_tag("form[action=?][method=post]", step_path(mock_step)) do
      with_tag('input#step_title[name=?]', "step[title]")
    end
  end
end
