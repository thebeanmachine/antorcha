require 'spec_helper'

describe "/items/edit.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:item] = @item = stub_model(Item,
      :new_record? => false,
      :description => "value for description",
      :inbox_id => "1"
    )
    assigns[:inbox] = @inbox = stub_model(Inbox, :title => "blaba")
  end

  it "renders the edit item form" do
    render

    response.should have_tag("form[action=#{inbox_item_path(@inbox,@item)}][method=post]") do
      with_tag('textarea#item_description[name=?]', "item[description]")
    end
  end
end
