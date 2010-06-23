require 'spec_helper'

describe "/tasks/show.html.erb" do
  include TasksHelper
  before(:each) do
    assigns[:task] = mock_task
    
    mock_task.stub \
      :title => "value for title",
      :name => "value for name",
      :procedure => mock_procedure
    
    mock_procedure.stub \
      :title => 'My Procedure'
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
  end
  
  it "has link to procedure" do
    render
    response.should have_tag('a[href=?]', procedure_path(mock_procedure), 'My Procedure')
  end
end
