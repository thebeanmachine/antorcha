require 'spec_helper'

describe "/instructions/edit.html.erb" do
  include InstructionsHelper

  before(:each) do
    assigns[:instruction] = mock_instruction
    assigns[:procedure] = mock_procedure
    
    mock_instruction.stub(
      :title => "value for title",
      :start => false,
      :errors => stub("errors").as_null_object
    )
    mock_procedure.stub( :title => 'value for procedure')
  end

  it "renders the edit instruction form" do
    render

    response.should have_tag("form[action=?][method=post]", instruction_path(mock_instruction)) do
      with_tag('input#instruction_title[name=?]', "instruction[title]")
    end
  end
end
