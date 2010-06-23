require 'spec_helper'

describe "/tasks/edit.html.erb" do
  include TasksHelper

  before(:each) do
    assigns[:task] = @task = stub_model(Task,
      :new_record? => false,
      :title => "value for title",
      :name => "value for name",
      :procedure => 1
    )
  end

  it "renders the edit task form" do
    render

    response.should have_tag("form[action=#{task_path(@task)}][method=post]") do
      with_tag('input#task_title[name=?]', "task[title]")
      with_tag("select#task_procedure_id[name=?]", "task[procedure_id]")
    end
  end
end
