require 'spec_helper'

describe DefinitionStepsController do
  
  before(:each) do
    act_as :advisor
  end
  
  def stub_controller
    mock_definition.stub :steps => mock_steps(:siblings)
  end
  
  describe "GET new" do
    def stub_new_action
      stub_controller
      stub_build_on(mock_steps(:siblings), mock_step)
      stub_find(mock_definition)
    end
    
    it "assigns a new step as @step" do
      stub_new_action
      get :new, :definition_id => mock_definition.to_param
      assigns[:step].should equal(mock_step)
    end

    it "assigns a new definition as @definition" do
      stub_new_action
      get :new, :definition_id => mock_definition.to_param
      assigns[:definition].should equal(mock_definition)
    end

    it "assigns a sibling steps as @steps" do
      stub_new_action
      get :new, :definition_id => mock_definition.to_param
      assigns[:steps].should == mock_steps(:siblings)
    end
  end
  
  describe "POST create" do
    
    def stub_create_action
      stub_controller
      stub_find(mock_definition)
      stub_build_on(mock_steps(:siblings), mock_step, 'these' => 'params')
    end
    
    def post_create
      post :create, :step => {:these => 'params'}, :definition_id => mock_definition.to_param
    end

    it "assigns sibling steps as @steps" do
      stub_successful_save_for(mock_step)
      stub_create_action
      post_create
      assigns[:steps].should == mock_steps(:siblings)
    end

    describe "with valid params" do
      it "assigns a newly created step as @step" do
        stub_successful_save_for(mock_step)
        stub_create_action
        post_create
        assigns[:step].should equal(mock_step)
      end

      it "redirects to the created step" do
        stub_successful_save_for(mock_step)
        stub_create_action
        post_create
        response.should redirect_to(step_url(mock_step))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved step as @step" do
        stub_unsuccessful_save_for(mock_step)
        stub_create_action
        post_create
        assigns[:step].should equal(mock_step)
      end

      it "re-renders the 'new' template" do
        stub_unsuccessful_save_for(mock_step)
        stub_create_action
        post_create
        response.should render_template('new')
      end
    end
  end
end
