require 'spec_helper'

describe "/tasks/new.html.erb" do
  include TasksHelper

  before(:each) do
    assigns[:task] = stub_model(Task,
      :new_record? => true,
      :title => "value for title",
      :name => "value for name",
      :procedure => nil
    )
    
    assigns[:procedures] = mock_procedures
    mock_procedure.stub :title => 'My Procedure'
  end

  it "renders new task form" do
    render

    response.should have_tag("form[action=?][method=post]", tasks_path) do
      with_tag("input#task_title[name=?]", "task[title]")
      with_tag("input[name=?]", "task[procedure_id]")
    end
  end
end
