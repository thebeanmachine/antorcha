require 'spec_helper'

describe "/task_steps/new.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:task] = mock_task
    assigns[:step] = mock_step
    
    mock_step.stub(
      :new_record? => true,
      :title => "value for title",
      :start => false,
      :errors => stub("errors").as_null_object
    )
    mock_step.as_new_record
    mock_task.stub( :title => "Task title" )
    
    mock_task.stub_chain(:errors, :[]).and_return(false)
  end

  it "renders new step form" do
    render

    response.should have_tag("form[action=?][method=post]", task_steps_path(mock_task)) do
      with_tag("input#step_title[name=?]", "step[title]")
    end
  end
end
