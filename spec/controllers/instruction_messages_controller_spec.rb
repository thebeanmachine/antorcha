require 'spec_helper'

describe InstructionMessagesController do

  def stub_find_instruction
    stub_find(mock_instruction)
  end

  describe "GET new" do

    def stub_get_new
      stub_find(mock_instruction)
      stub_new(mock_message)
    end

    def get_new
      get :new, :instruction_id => mock_instruction.to_param
    end
    
    
    it "assigns the parent instruction as @instruction" do
      stub_get_new
      get_new
      assigns[:instruction].should equal(mock_instruction)
    end
    
    it "assigns a new message as @message" do
      stub_get_new
      get_new
      assigns[:message].should equal(mock_message)
    end
  end


  describe "POST create" do
    
    def stub_create
      stub_find_instruction
      mock_instruction.stub(:messages => mock_messages)
      stub_new_on(mock_messages, mock_message, 'these' => 'params')
    end
    
    def post_create
      post :create, :instruction_id => mock_instruction.to_param, :message => {'these' => 'params'}
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
      
      it "assigns the parent instruction as @instruction" do
        stub_with_valid_params
        post_create
        assigns[:instruction].should equal(mock_instruction)
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

      it "assigns the parent instruction as @instruction" do
        stub_with_invalid_params
        post_create
        assigns[:instruction].should equal(mock_instruction)
      end
    end
  end
  
end
