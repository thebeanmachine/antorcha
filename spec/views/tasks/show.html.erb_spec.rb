require 'spec_helper'

describe "/tasks/show.html.erb" do
  include TasksHelper
  before(:each) do
    assigns[:task] = @task = stub_model(Task,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ name/)
  end
end
