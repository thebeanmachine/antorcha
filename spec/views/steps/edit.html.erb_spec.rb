require 'spec_helper'

describe "/steps/edit.html.erb" do
  
  def stub_render
    assigns[:step] = mock_step
    assigns[:definition] = mock_definition

    mock_definition.stub \
      :title => 'Definitie titel'
    
    mock_step.stub \
      :title => 'Stap titel'
      
    stub_render_partial
  end

  it "should render the title" do
    stub_render
    render
    should have_tag('h1', /Stap titel/)
  end

  it "should render link to definition" do
    stub_render
    render
    should have_tag('a', /Definitie titel/)
  end
  
  it "should call the _form partial" do
    stub_render
    should_render_partial "form"
    render
  end
end
