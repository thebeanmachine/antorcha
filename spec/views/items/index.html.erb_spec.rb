require 'spec_helper'

describe "/items/index.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:items] = [
      stub_model(Item,
        :description => "value for description",
        :inbox_id => "1"
      ),
      stub_model(Item,
        :description => "value for description",
        :inbox_id => "1"
      )
    ]
  end

  it "renders a list of items" do
    render
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
