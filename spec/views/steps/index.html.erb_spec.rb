require 'spec_helper'

describe "/steps/index.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:steps] = [
      stub_model(Step,
        :title => "value for title"
      ),
      stub_model(Step,
        :title => "value for title"
      )
    ]
  end

  it "renders a list of steps" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
