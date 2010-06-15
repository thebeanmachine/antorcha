require 'spec_helper'

describe "/inboxes/show.html.erb" do
  include InboxesHelper
  before(:each) do
    assigns[:inbox] = @inbox = stub_model(Inbox,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ description/)
  end
end
