require 'spec_helper'

describe "/items/new.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:item] = stub_model(Item,
      :new_record? => true,
      :description => "value for description",
      :inbox_id => "1"
    )
    assigns[:inbox] = @inbox = stub_model(Inbox, :title => "blaba")
  end

  it "renders new item form" do
    render

    response.should have_tag("form[action=?][method=post]", inbox_items_path(@inbox)) do
      with_tag("textarea#item_description[name=?]", "item[description]")
    end
  end
end
