require 'spec_helper'

describe "/inboxes/new.html.erb" do
  include InboxesHelper

  before(:each) do
    assigns[:inbox] = stub_model(Inbox,
      :new_record? => true,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders new inbox form" do
    render

    response.should have_tag("form[action=?][method=post]", inboxes_path) do
      with_tag("input#inbox_title[name=?]", "inbox[title]")
      with_tag("textarea#inbox_description[name=?]", "inbox[description]")
    end
  end
end
