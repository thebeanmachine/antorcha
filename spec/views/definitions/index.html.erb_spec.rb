require 'spec_helper'

describe "/definitions/index.html.erb" do
  include DefinitionsHelper

  before(:each) do
    assigns[:definitions] = [
      stub_model(Definition,
        :title => "value for title",
        :name => "value for name"
      ),
      stub_model(Definition,
        :title => "value for title",
        :name => "value for name"
      )
    ]
  end

  it "renders a list of definitions" do
    render
    response.should have_tag("a", "value for title".to_s, 2)
  end
end
