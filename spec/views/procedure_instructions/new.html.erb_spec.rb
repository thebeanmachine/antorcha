require 'spec_helper'

describe "/procedure_instructions/new.html.erb" do
  include InstructionsHelper

  before(:each) do
    assigns[:procedure] = mock_procedure
    assigns[:instruction] = mock_instruction
    
    mock_instruction.stub(
      :new_record? => true,
      :title => "value for title",
      :start => false,
      :errors => stub("errors").as_null_object
    )
    mock_instruction.as_new_record
    mock_procedure.stub( :title => "Procedure title" )
    
    mock_procedure.stub_chain(:errors, :[]).and_return(false)
  end

  it "renders new instruction form" do
    render

    response.should have_tag("form[action=?][method=post]", procedure_instructions_path(mock_procedure)) do
      with_tag("input#instruction_title[name=?]", "instruction[title]")
    end
  end
end
