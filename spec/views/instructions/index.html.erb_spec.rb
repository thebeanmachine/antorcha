require 'spec_helper'

describe "/instructions/index.html.erb" do
  include InstructionsHelper

  before(:each) do
    assigns[:instructions] = [
      stub_model(Instruction,
        :title => "value for title", :procedure => mock_procedure
      ),
      stub_model(Instruction,
        :title => "value for title", :procedure => mock_procedure
      )
    ]
    mock_procedure.stub(:title => 'My Procedure')
  end

  it "renders a list of instructions" do
    render
    response.should have_tag("li a", "value for title".to_s, 2)
  end
end
