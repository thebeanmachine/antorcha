require 'spec_helper'

describe "/instructions/index.html.erb" do
  include InstructionsHelper

  before(:each) do
    assigns[:instructions] = [
      stub_model(Instruction,
        :title => "value for title"
      ),
      stub_model(Instruction,
        :title => "value for title"
      )
    ]
  end

  it "renders a list of instructions" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
