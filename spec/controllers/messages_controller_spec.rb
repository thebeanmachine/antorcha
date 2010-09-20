require 'spec_helper'

describe MessagesController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  describe "GET index" do
    def stub_index
      Message.stub(:search => mock_search)
      # mock_search.stub(:all => mock_messages)
      mock_search.stub(:paginate => mock_messages)
    end
  
    it "uses searchlogic" do
      stub_index
      Message.should_receive(:search).with("a query")
      get :index, :search => 'a query'
    end
  
    it "assigns all messages as @messages" do
      stub_index
      get :index
      assigns[:messages].should == mock_messages
    end

    it "should include transactions" do
      stub_index
      # mock_search.should_receive(:all).with(hash_including(:include => :transaction)).and_return(mock_messages)
      mock_search.should_receive(:paginate).with(hash_including(:include => :transaction)).and_return(mock_messages)
      get :index
    end
  end

  describe "GET show" do
    def stub_get_action
      stub_find(mock_message)
      mock_message.stub(:shown! => nil)
    end
    
    def get_show
      get :show, :id => mock_message.to_param
    end
  
    it "assigns the requested message as @message" do
      stub_get_action
      get_show
      assigns[:message].should equal(mock_message)
    end
  
    it "should flag the message as shown" do
      stub_get_action
      mock_message.should_receive(:shown!)
      get_show
    end
    
    it "authorizes show on the @message" do
      stub_get_action
      controller.should_receive(:authorize!).with(:show, mock_message)
      get_show
    end
    
  end

  describe "GET edit" do
    before(:each) do
      Message.stub(:find).with("37").and_return(mock_message)
      mock_message.stub :updatable? => true
    end

    it "assigns the requested message as @message" do
      get :edit, :id => "37"
      assigns[:message].should equal(mock_message)
    end

    it "authorizes edit on the @message" do
      controller.should_receive(:authorize!).with(:edit, mock_message)
      get :edit, :id => "37"
    end

  end

  describe "PUT update" do

    def stub_update_action
      stub_find(mock_message)
    end

    def put_update
      put :update, :id => mock_message.to_param, :message => {:these => 'params'}
    end

    describe "with valid params" do
      def stub_succesful_update_action
        stub_update_action
        stub_succesful_update(mock_message, {'these' => 'params'})
      end
      
      it "authorizes update on the @message" do
        stub_succesful_update_action
        controller.should_receive(:authorize!).with(:update, mock_message)
        put_update
      end
      
      it "updates the requested message" do
        Message.should_receive(:find).with("37").and_return(mock_message)
        mock_message.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :message => {:these => 'params'}
      end

      it "assigns the requested message as @message" do
        mock_message.stub(:update_attributes => true)
        Message.stub(:find).and_return(mock_message())
        put :update, :id => "1"
        assigns[:message].should equal(mock_message)
      end

      it "redirects to the message" do
        mock_message.stub(:update_attributes => true)
        Message.stub(:find).and_return(mock_message)
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
        mock_message.stub(:update_attributes => false)
        Message.stub(:find).and_return(mock_message)
        put :update, :id => "1"
        assigns[:message].should equal(mock_message)
      end

      it "re-renders the 'edit' template" do
        mock_message.stub(:update_attributes => false)
        Message.stub(:find).and_return(mock_message)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
  end

  describe "POST create" do

    it "should be deprecated" do
      
      lambda { post :create }.should raise_error(/^DEPRECATED/)
    end
    
    # def stub_create_and_from_hash
    #   stub_new(mock_message)
    #   mock_message.stub(:from_hash).and_return(mock_message)
    #   mock_message.stub(:incoming= => nil)
    # end
    # 
    # def post_create
    #   post :create, :message => {'these' => 'params'}
    # end
    # 
    # describe "with valid params" do
    #   def stub_with_valid_params
    #     stub_create_and_from_hash
    #     stub_successful_save_for(mock_message)
    #   end
    #   
    #   it "should implement peer-to-peer authentication"
    #   
    #   it "should not authorize create on the @message, because it is an api call (will change after implementing peer-to-peer authentication)" do
    #     stub_with_valid_params
    #     controller.should_not_receive(:authorize!).with(:create, mock_message)
    #     post_create
    #   end
    #         
    #   it "uses from_hash to create the message" do
    #     stub_with_valid_params
    #     mock_message.should_receive(:from_hash).with({'these' => 'params'})
    #     post_create
    #   end
    #         
    #   it "assigns a newly created message as @message" do
    #     stub_with_valid_params
    #     post_create
    #     assigns[:message].should equal(mock_message)
    #   end
    # 
    #   it "response status should be http 'Created'" do
    #     stub_with_valid_params
    #     post_create
    #     response.status.should == '201 Created'
    #   end
    #   
    #   it "flags message as incoming" do
    #     stub_with_valid_params
    #     mock_message.should_receive(:incoming=).with(true)
    #     post_create
    #   end
    # end
    # 
    # describe "with invalid params" do
    #   def stub_with_invalid_params
    #     stub_create_and_from_hash
    #     stub_unsuccessful_save_for(mock_message)
    #   end
    #   
    #   it "assigns a newly created but unsaved message as @message" do
    #     stub_with_invalid_params
    #     post_create
    #     assigns[:message].should equal(mock_message)
    #   end
    # 
    #   it "re-renders the 'new' template" do
    #     stub_with_invalid_params
    #     post_create
    #     response.status.should == '422 Unprocessable Entity'
    #   end
    # end
  end


  # describe "DELETE destroy" do
  #   it "destroys the requested message" do
  #     Message.should_receive(:find).with("37").and_return(mock_message)
  #     mock_message.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the messages list" do
  #     mock_message.stub(:destroy => true)
  #     Message.stub(:find).and_return(mock_message)
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(messages_url)
  #   end
  # end

end
