require 'spec_helper'

describe "/items/index.html.erb" do
  include ItemsHelper

  before(:each) do
    assigns[:items] = [
      stub_model(Item,
        :title => ,
        :description => "value for description"
      ),
      stub_model(Item,
        :title => ,
        :description => "value for description"
      )
    ]
  end

  it "renders a list of items" do
    render
    response.should have_tag("tr>td", .to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
