require 'spec_helper'

describe MessagesController do

  def mock_message(stubs={})
    @mock_message ||= mock_model(Message, stubs)
  end
  
  def mock_step
    @mock_step ||= mock_model(Step)
  end

  describe "GET index" do
    def stub_index
      stub_all(mock_message)
      Step.stub(:to_start_with => [mock_step])
    end
    
    it "assigns all messages as @messages" do
      stub_index
      get :index
      assigns[:messages].should == [mock_message]
    end
    
    it "assigns steps to start with" do
      stub_index
      get :index
      assigns[:steps_to_start_with].should == [mock_step]
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message" do
      Message.stub(:find).with("37").and_return(mock_message)
      get :show, :id => "37"
      assigns[:message].should equal(mock_message)
    end
  end

  describe "GET edit" do
    it "assigns the requested message as @message" do
      Message.stub(:find).with("37").and_return(mock_message)
      get :edit, :id => "37"
      assigns[:message].should equal(mock_message)
    end
  end

  describe "POST create" do
    
    def stub_create_and_from_hash
      stub_new(mock_message)
      mock_message.stub(:from_hash).and_return(mock_message)
      mock_message.stub(:incoming= => nil)
    end
    
    def post_create
      post :create, :message => {'these' => 'params'}
    end

    describe "with valid params" do
      def stub_with_valid_params
        stub_create_and_from_hash
        stub_successful_save_for(mock_message)
      end
            
      it "uses from_hash to create the message" do
        stub_with_valid_params
        mock_message.should_receive(:from_hash).with({'these' => 'params'})
        post_create
      end
            
      it "assigns a newly created message as @message" do
        stub_with_valid_params
        post_create
        assigns[:message].should equal(mock_message)
      end

      it "response status should be http 'Created'" do
        stub_with_valid_params
        post_create
        response.status.should == '201 Created'
      end
      
      it "flags message as incoming" do
        stub_with_valid_params
        mock_message.should_receive(:incoming=).with(true)
        post_create
      end
    end

    describe "with invalid params" do
      def stub_with_invalid_params
        stub_create_and_from_hash
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
        response.status.should == '422 Unprocessable Entity'
      end
    end
  end


  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested message" do
        Message.should_receive(:find).with("37").and_return(mock_message)
        mock_message.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :message => {:these => 'params'}
      end

      it "assigns the requested message as @message" do
        Message.stub(:find).and_return(mock_message(:update_attributes => true))
        put :update, :id => "1"
        assigns[:message].should equal(mock_message)
      end

      it "redirects to the message" do
        Message.stub(:find).and_return(mock_message(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(message_url(mock_message))
      end
    end

    describe "with invalid params" do
      it "updates the requested message" do
        Message.should_receive(:find).with("37").and_return(mock_message)
        mock_message.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :message => {:these => 'params'}
      end

      it "assigns the message as @message" do
        Message.stub(:find).and_return(mock_message(:update_attributes => false))
        put :update, :id => "1"
        assigns[:message].should equal(mock_message)
      end

      it "re-renders the 'edit' template" do
        Message.stub(:find).and_return(mock_message(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested message" do
      Message.should_receive(:find).with("37").and_return(mock_message)
      mock_message.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the messages list" do
      Message.stub(:find).and_return(mock_message(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(messages_url)
    end
  end

end
