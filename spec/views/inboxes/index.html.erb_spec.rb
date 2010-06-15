require 'spec_helper'

describe "/inboxes/index.html.erb" do
  include InboxesHelper

  before(:each) do
    assigns[:inboxes] = [
      stub_model(Inbox,
        :title => "value for title",
        :description => "value for description"
      ),
      stub_model(Inbox,
        :title => "value for title",
        :description => "value for description"
      )
    ]
  end

  it "renders a list of inboxes" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
