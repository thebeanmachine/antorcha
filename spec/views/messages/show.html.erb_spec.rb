require 'spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper
  before(:each) do
    assigns[:message] = @message = stub_model(Message,
      :title => "value for title",
      :body => "value for body",
      :include => true
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ body/)
  end
end
