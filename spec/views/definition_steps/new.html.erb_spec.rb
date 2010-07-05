require 'spec_helper'

describe "/definition_steps/new.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:definition] = mock_definition
    assigns[:step] = mock_step
    
    mock_step.stub \
      :new_record? => true,
      :title => "value for title",
      :start => false,
      :destination_url => 'http://example.com/messages',
      :errors => stub("errors").as_null_object,
      :definition_roles => mock_roles,
      :role_ids => []

    mock_step.as_new_record
    mock_definition.stub( :title => "Definition title" )
    
    mock_definition.stub_chain(:errors, :[]).and_return(false)
  end

  it "renders new step form" do
    render

    response.should have_tag("form[action=?][method=post]", definition_steps_path(mock_definition)) do
      with_tag("input#step_title[name=?]", "step[title]")
    end
  end
end
