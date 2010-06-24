require 'spec_helper'

describe StepMessagesController do

  def stub_find_step
    stub_find(mock_step)
  end

  describe "GET new" do

    def stub_get_new
      stub_find(mock_step)
      stub_new(mock_message)
    end

    def get_new
      get :new, :step_id => mock_step.to_param
    end
    
    
    it "assigns the parent step as @step" do
      stub_get_new
      get_new
      assigns[:step].should equal(mock_step)
    end
    
    it "assigns a new message as @message" do
      stub_get_new
      get_new
      assigns[:message].should equal(mock_message)
    end
  end


  describe "POST create" do
    
    def stub_create
      stub_find_step
      mock_step.stub(:messages => mock_messages)
      stub_new_on(mock_messages, mock_message, 'these' => 'params')
    end
    
    def post_create
      post :create, :step_id => mock_step.to_param, :message => {'these' => 'params'}
    end

    describe "with valid params" do
      def stub_with_valid_params
        stub_create
        stub_successful_save_for(mock_message)
      end
            
      it "assigns a newly created message as @message" do
        stub_with_valid_params
        post_create
        assigns[:message].should equal(mock_message)
      end

      it "redirects to the created message" do
        stub_with_valid_params
        post_create
        response.should redirect_to(message_url(mock_message))
      end
      
      it "assigns the parent step as @step" do
        stub_with_valid_params
        post_create
        assigns[:step].should equal(mock_step)
      end
    end

    describe "with invalid params" do
      def stub_with_invalid_params
        stub_create
        stub_unsuccessful_save_for(mock_message)
      end
      
      it "assigns a newly created but unsaved message as @message" do
        stub_with_invalid_params
        post_create
        assigns[:message].should equal(mock_message)
      end

      it "re-renders the 'new' template" do
        stub_with_invalid_params
        post_create
        response.should render_template('new')
      end

      it "assigns the parent step as @step" do
        stub_with_invalid_params
        post_create
        assigns[:step].should equal(mock_step)
      end
    end
  end
  
end
