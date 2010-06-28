require 'spec_helper'

describe "/steps/index.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:steps] = [
      stub_model(Step,
        :title => "value for title", :definition => mock_definition
      ),
      stub_model(Step,
        :title => "value for title", :definition => mock_definition
      )
    ]
    mock_definition.stub(:title => 'My Definition')
    act_as :maintainer
  end

  it "renders a list of steps" do
    render
    response.should have_tag("li a", "value for title".to_s, 2)
  end
end
