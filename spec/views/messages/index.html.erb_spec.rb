require 'spec_helper'

describe "/messages/index.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:messages] = [
      stub_model(Message,
        :title => "value for title",
        :body => "value for body"
      ),
      stub_model(Message,
        :title => "value for title",
        :body => "value for body"
      )
    ]
  end

  it "renders a list of messages" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
  end
end
