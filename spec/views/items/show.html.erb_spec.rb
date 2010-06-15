require 'spec_helper'

describe "/items/show.html.erb" do
  include ItemsHelper
  before(:each) do
    assigns[:item] = @item = stub_model(Item,
      :description => "value for description",
      :inbox_id => "1"
    )
    assigns[:inbox] = stub_model(Inbox, :title => "blaba")
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(//)
    response.should have_text(/value\ for\ description/)
  end
end
