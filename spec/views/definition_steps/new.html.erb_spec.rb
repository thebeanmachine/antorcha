require 'spec_helper'

describe "/definition_steps/new.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:step] = mock_step
    assigns[:definition] = mock_definition

    mock_definition.stub \
      :title => 'Definitie titel'
    
    stub_render_partial
  end

  it "renders new step form" do
    should_render_partial 'steps/form'
    render
  end
end

