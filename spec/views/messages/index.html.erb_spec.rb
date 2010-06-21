require 'spec_helper'

describe "/messages/index.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:messages] = [
      mock_message,
      stub_model(Message,
        :title => "value for title",
        :body => "value for body",
        :shown? => false,
        :step => mock_step,
        :incoming? => false
      )
    ]

    mock_message.stub \
      :title => "value for title",
      :body => "value for body",
      :shown? => :shown,
      :sent? => false,
      :step => mock_step,
      :incoming? => false
      
    
    mock_step.stub :title => 'step title', :task => mock_task
    mock_task.stub :title => 'task title'
    
    
    assigns[:steps_to_start_with] = []
  end

  it "renders titles" do
    render
    response.should have_tag("tr.message>td", "value for title".to_s, 2)
  end

  it "renders titles of steps" do
    render
    response.should have_tag("tr.message>td", "step title".to_s, 2)
  end

  it "renders titles of tasks" do
    render
    response.should have_tag("tr.message>td", "task title".to_s, 2)
  end

  it "links to message show" do
    render
    response.should have_tag("a[href=?]", message_path(mock_message), 1)
  end


  it "renders a shown message" do
    render
    response.should have_tag("tr.message.shown", 1)
  end

end
