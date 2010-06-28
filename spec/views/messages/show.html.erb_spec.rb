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
      :step => mock_step,
      :transaction => mock_transaction,
      :delivered? => false,
      :sent? => true,
      :sent_at => Time.now
    )
    mock_step.stub( :title => 'hallo wereld', :definition => mock_definition )
    mock_definition.stub( :title => 'hallo wereld' )
    mock_transaction.stub( :title => 'hallo wereld' )
  end

  it "renders attributes in <p>" do
    render
    response.should have_tag('h1', /value\ for\ title/)
    response.should have_tag('p', /hallo wereld/)
    response.should have_text(/value\ for\ body/)
  end
  
  it "renders link to delivery if not sent" do
    act_as :sender
    mock_message.stub(:sent? => false)
    render
    response.should have_tag('form[action=?] input[type=submit][value=?]', message_delivery_path(mock_message), 'Send Message') 
  end
end
