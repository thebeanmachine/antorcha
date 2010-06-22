require 'spec_helper'

describe InstructionsController do

  def mock_instruction(stubs={})
    @mock_instruction ||= mock_model(Instruction, stubs)
  end

  describe "GET index" do
    it "assigns all instructions as @instructions" do
      Instruction.stub(:find).with(:all).and_return([mock_instruction])
      get :index
      assigns[:instructions].should == [mock_instruction]
    end
  end

  def stub_show_or_edit
    stub_find(mock_instruction)
    mock_instruction.stub(:procedure => mock_procedure)
  end

  describe "GET show" do
    it "assigns the requested instruction as @instruction" do
      stub_show_or_edit
      get :show, :id => mock_instruction.to_param
      assigns[:instruction].should equal(mock_instruction)
    end
  end

  describe "GET edit" do
    it "assigns the requested instruction as @instruction" do
      stub_show_or_edit
      get :edit, :id => mock_instruction.to_param
      assigns[:instruction].should equal(mock_instruction)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested instruction" do
        Instruction.should_receive(:find).with("37").and_return(mock_instruction)
        mock_instruction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instruction => {:these => 'params'}
      end

      it "assigns the requested instruction as @instruction" do
        Instruction.stub(:find).and_return(mock_instruction(:update_attributes => true))
        put :update, :id => "1"
        assigns[:instruction].should equal(mock_instruction)
      end

      it "redirects to the instruction" do
        Instruction.stub(:find).and_return(mock_instruction(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(instruction_url(mock_instruction))
      end
    end

    describe "with invalid params" do
      it "updates the requested instruction" do
        Instruction.should_receive(:find).with("37").and_return(mock_instruction)
        mock_instruction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :instruction => {:these => 'params'}
      end

      it "assigns the instruction as @instruction" do
        Instruction.stub(:find).and_return(mock_instruction(:update_attributes => false))
        put :update, :id => "1"
        assigns[:instruction].should equal(mock_instruction)
      end

      it "re-renders the 'edit' template" do
        Instruction.stub(:find).and_return(mock_instruction(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    def stub_destroy_action
      stub_find(mock_instruction)
      mock_instruction.stub(:destroy => true, :procedure => mock_procedure)
    end
    
    it "destroys the requested instruction" do
      stub_destroy_action
      mock_instruction.should_receive(:destroy)
      delete :destroy, :id => mock_instruction.to_param
    end

    it "redirects to the instructions list" do
      stub_destroy_action
      delete :destroy, :id => mock_instruction.to_param
      response.should redirect_to(procedure_path(mock_procedure))
    end
  end

end
