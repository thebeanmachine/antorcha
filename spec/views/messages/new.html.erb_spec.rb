require 'spec_helper'

describe "/messages/new.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:message] = stub_model(Message,
      :new_record? => true,
      :title => "value for title",
      :body => "value for body"
    )
  end

  it "renders new message form" do
    render

    response.should have_tag("form[action=?][method=post]", messages_path) do
      with_tag("input#message_title[name=?]", "message[title]")
      with_tag("textarea#message_body[name=?]", "message[body]")
    end
  end
end
