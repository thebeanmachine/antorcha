require 'spec_helper'

describe ProcedureInstructionsController do
  
  describe "GET new" do
    def stub_new_action
      stub_new(mock_instruction)
      stub_find(mock_procedure)
    end
    
    it "assigns a new instruction as @instruction" do
      stub_new_action
      get :new, :procedure_id => mock_procedure.to_param
      assigns[:instruction].should equal(mock_instruction)
    end

    it "assigns a new instruction as @instruction" do
      stub_new_action
      get :new, :procedure_id => mock_procedure.to_param
      assigns[:procedure].should equal(mock_procedure)
    end

  end
  
  describe "POST create" do
    
    def stub_create_action
      stub_find(mock_procedure)
      stub_new_on(mock_instructions, mock_instruction, 'these' => 'params')
      mock_procedure.stub(:instructions => mock_instructions)
    end
    
    def post_create
      post :create, :instruction => {:these => 'params'}, :procedure_id => mock_procedure.to_param
    end

    describe "with valid params" do
      it "assigns a newly created instruction as @instruction" do
        stub_successful_save_for(mock_instruction)
        stub_create_action
        post_create
        assigns[:instruction].should equal(mock_instruction)
      end

      it "redirects to the created instruction" do
        stub_successful_save_for(mock_instruction)
        stub_create_action
        post_create
        response.should redirect_to(instruction_url(mock_instruction))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved instruction as @instruction" do
        stub_unsuccessful_save_for(mock_instruction)
        stub_create_action
        post_create
        assigns[:instruction].should equal(mock_instruction)
      end

      it "re-renders the 'new' template" do
        stub_unsuccessful_save_for(mock_instruction)
        stub_create_action
        post_create
        response.should render_template('new')
      end
    end
  end
end
