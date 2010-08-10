require 'spec_helper'

describe "/messages/edit.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:message] = @message = stub_model(Message,
      :new_record? => false,
      :step => stub_model(Step, :title=>'title'),
      :title => "value for title",
      :body => "value for body"
    )
  end

  it "renders the edit message form" do
    render

    response.should have_tag("form[action=#{message_path(@message)}][method=post]") do
      with_tag('input#message_title[name=?]', "message[title]")
      with_tag('textarea#message_body[name=?]', "message[body]")
    end
  end
end
