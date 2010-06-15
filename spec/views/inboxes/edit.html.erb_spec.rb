require 'spec_helper'

describe "/inboxes/edit.html.erb" do
  include InboxesHelper

  before(:each) do
    assigns[:inbox] = @inbox = stub_model(Inbox,
      :new_record? => false,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders the edit inbox form" do
    render

    response.should have_tag("form[action=#{inbox_path(@inbox)}][method=post]") do
      with_tag('input#inbox_title[name=?]', "inbox[title]")
      with_tag('textarea#inbox_description[name=?]', "inbox[description]")
    end
  end
end
