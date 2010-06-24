require 'spec_helper'

describe StepsController do

  def mock_step(stubs={})
    @mock_step ||= mock_model(Step, stubs)
  end

  describe "GET index" do
    it "assigns all steps as @steps" do
      Step.stub(:find).with(:all).and_return([mock_step])
      get :index
      assigns[:steps].should == [mock_step]
    end
  end

  def stub_show_or_edit
    stub_find(mock_step)
    mock_step.stub(:definition => mock_definition)
  end

  describe "GET show" do
    it "assigns the requested step as @step" do
      stub_show_or_edit
      get :show, :id => mock_step.to_param
      assigns[:step].should equal(mock_step)
    end
  end

  describe "GET edit" do
    it "assigns the requested step as @step" do
      stub_show_or_edit
      get :edit, :id => mock_step.to_param
      assigns[:step].should equal(mock_step)
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested step" do
        Step.should_receive(:find).with("37").and_return(mock_step)
        mock_step.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :step => {:these => 'params'}
      end

      it "assigns the requested step as @step" do
        Step.stub(:find).and_return(mock_step(:update_attributes => true))
        put :update, :id => "1"
        assigns[:step].should equal(mock_step)
      end

      it "redirects to the step" do
        Step.stub(:find).and_return(mock_step(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(step_url(mock_step))
      end
    end

    describe "with invalid params" do
      it "updates the requested step" do
        Step.should_receive(:find).with("37").and_return(mock_step)
        mock_step.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :step => {:these => 'params'}
      end

      it "assigns the step as @step" do
        Step.stub(:find).and_return(mock_step(:update_attributes => false))
        put :update, :id => "1"
        assigns[:step].should equal(mock_step)
      end

      it "re-renders the 'edit' template" do
        Step.stub(:find).and_return(mock_step(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    def stub_destroy_action
      stub_find(mock_step)
      mock_step.stub(:destroy => true, :definition => mock_definition)
    end
    
    it "destroys the requested step" do
      stub_destroy_action
      mock_step.should_receive(:destroy)
      delete :destroy, :id => mock_step.to_param
    end

    it "redirects to the steps list" do
      stub_destroy_action
      delete :destroy, :id => mock_step.to_param
      response.should redirect_to(definition_path(mock_definition))
    end
  end

end
