require 'spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper
  before(:each) do
    assigns[:message] = mock_message
    
    mock_message.stub(
      :title => "value for title",
      :body => "value for body",
      :include => true,
      :incoming? => true,
      :step => mock_step
    )
    mock_step.stub( :title => 'hallo wereld' )
  end

  it "renders attributes in <p>" do
    render
    response.should have_tag('h1', /value\ for\ title/)
    response.should have_tag('p', /hallo wereld/)
    response.should have_text(/value\ for\ body/)
  end
end
