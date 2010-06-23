require 'spec_helper'

describe "/tasks/index.html.erb" do
  include TasksHelper

  before(:each) do
    assigns[:tasks] = [
      stub_model(Task,
        :title => "value for title",
        :name => "value for name",
        :procedure => mock_procedure
      ),
      stub_model(Task,
        :title => "value for title",
        :name => "value for name",
        :procedure => mock_procedure
      )
    ]
    
    mock_procedure.stub \
      :title => 'My Procedure'
  end

  it "renders a list of tasks" do
    render
    response.should have_tag("ul li a", "value for title".to_s, 2)
  end
end
