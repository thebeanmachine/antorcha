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
        :instruction => mock_instruction,
        :incoming? => false
      )
    ]

    mock_message.stub \
      :title => "value for title",
      :body => "value for body",
      :shown? => :shown,
      :sent? => false,
      :instruction => mock_instruction,
      :incoming? => false
      
    
    mock_instruction.stub :title => 'instruction title', :procedure => mock_procedure
    mock_procedure.stub :title => 'procedure title'
    
    
    assigns[:instructions_to_start_with] = []
  end

  it "renders titles" do
    render
    response.should have_tag("tr.message>td", "value for title".to_s, 2)
  end

  it "renders titles of instructions" do
    render
    response.should have_tag("tr.message>td", "instruction title".to_s, 2)
  end

  it "renders titles of procedures" do
    render
    response.should have_tag("tr.message>td", "procedure title".to_s, 2)
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
