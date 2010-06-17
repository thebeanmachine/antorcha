require 'spec_helper'

describe TaskStepsController do
  
  describe "GET new" do
    def stub_new_action
      stub_new(mock_step)
      stub_find(mock_task)
    end
    
    it "assigns a new step as @step" do
      stub_new_action
      get :new, :task_id => mock_task.to_param
      assigns[:step].should equal(mock_step)
    end

    it "assigns a new step as @step" do
      stub_new_action
      get :new, :task_id => mock_task.to_param
      assigns[:task].should equal(mock_task)
    end

  end
  
  describe "POST create" do
    
    def post_create
      post :create, :step => {:these => 'params'}, :task_id => mock_task.to_param
    end

    describe "with valid params" do
      it "assigns a newly created step as @step" do
        stub_successful_save_for(mock_step)
        stub_new(mock_step, 'these' => 'params')
        post_create
        assigns[:step].should equal(mock_step)
      end

      it "redirects to the created step" do
        stub_successful_save_for(mock_step)
        stub_new(mock_step)
        post_create
        response.should redirect_to(step_url(mock_step))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved step as @step" do
        stub_unsuccessful_save_for(mock_step)
        stub_new(mock_step, 'these' => 'params')
        post_create
        assigns[:step].should equal(mock_step)
      end

      it "re-renders the 'new' template" do
        stub_unsuccessful_save_for(mock_step)
        stub_new(mock_step, 'these' => 'params')
        post_create
        response.should render_template('new')
      end
    end
  end
end
