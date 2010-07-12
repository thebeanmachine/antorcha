require 'spec_helper'

describe "/castables/index.html.erb" do
  include CastablesHelper

  before(:each) do
    assigns[:castables] = [
      stub_model(Castable,
        :user => 1,
        :role => 1
      ),
      stub_model(Castable,
        :user => 1,
        :role => 1
      )
    ]
  end

  it "renders a list of castables" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
