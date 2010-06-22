require 'spec_helper'

describe "/instructions/show.html.erb" do
  include InstructionsHelper
  before(:each) do
    assigns[:instruction] = @instruction = stub_model(Instruction,
      :title => "value for title"
    )
    assigns[:procedure] = mock_procedure
    mock_procedure.stub(:title => 'value for procedure')
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
  end
end
