require 'spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper
  before(:each) do
    assigns[:message] = mock_message
    
    mock_message.stub(
      :title => "value for title",
      :body => "value for body",
      :include => true,
      :incoming? => false,
      :instruction => mock_instruction,
      :delivered? => false,
      :sent? => true,
      :sent_at => Time.now
    )
    mock_instruction.stub( :title => 'hallo wereld' )
  end

  it "renders attributes in <p>" do
    render
    response.should have_tag('h1', /value\ for\ title/)
    response.should have_tag('p', /hallo wereld/)
    response.should have_text(/value\ for\ body/)
  end
  
  it "renders link to delivery if not sent" do
    mock_message.stub(:sent? => false)
    render
    response.should have_tag('form[action=?] input[type=submit][value=?]', message_delivery_path(mock_message), 'Verstuur') 
  end
end
