require 'spec_helper'

describe MessagesController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  def stub_cannot_examine_messages
    controller.stub(:cannot?).with(:examine, Message).and_return(true)
  end

  def stub_can_examine_messages
    controller.stub(:cannot?).with(:examine, Message).and_return(false)
  end

  describe "GET index" do
    def stub_index
      Message.stub(:search => mock_search)
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
    
    describe "as XML" do
      before(:each) do
        stub_index
        mock_search.stub(:all => mock_messages)
        mock_messages.each {|m| m.stub :to_xml => 'niets'}
        controller.stub :cannot? => true
      end


      
      def mock_messages_should_receive_to_xml_with_scrub what 
        mock_messages.each do |m| m.should_receive(:to_xml).with(hash_including(:scrub => what)).and_return('squat') end        
      end

      it "should render xml" do
        get :index, :format => 'xml'
        response.body.should have_text(/<messages.*<\/messages>/mi)
      end
      
      it "should not scrub messages if user can examine messages" do
        stub_can_examine_messages
        mock_messages_should_receive_to_xml_with_scrub false
        get :index, :format => 'xml'
      end

      it "should scrub messages if user cannot examine messages" do
        stub_cannot_examine_messages
        mock_messages_should_receive_to_xml_with_scrub true
        get :index, :format => 'xml'
      end
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
        put :update, :id => "1", :message => {:body => 'sdf'}
        assigns[:message].should equal(mock_message)
      end

      it "redirects to the message" do
        mock_message.stub(:update_attributes => true)
        Message.stub(:find).and_return(mock_message)
        put :update, :id => "1", :message => {:body => 'sdf'}
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
        put :update, :id => "1", :message => {:body => 'sdf'}
        assigns[:message].should equal(mock_message)
      
      end

      it "re-renders the 'edit' template" do
        mock_message.stub(:update_attributes => false)
        Message.stub(:find).and_return(mock_message)
        put :update, :id => "1", :message => {:body => 'sdf'}
        response.should render_template('edit')
      end
    end
  end

  describe "POST create - for creating ReST replies" do

    before(:each) do
      stub_new mock_message(:reply)
      
      mock_message(:reply).stub :request => mock_message(:request)
      controller.stub :current_user => mock_user
      mock_message(:reply).stub :save => true
      
      mock_message(:reply).stub :to_xml => "<xml/>"
      
      stub_authorize!
    end
    
    def message_params
      { 'aap' => :noot }
    end
    def post_create
      post :create, :request_message_id => mock_message(:request).to_param, :message => message_params
    end

    it "should not be deprecated" do
      lambda { post :create }.should_not raise_error(/^DEPRECATED/)
    end

    it "should find the request message and use it to create the message" do
      post_create
      assigns[:request_message].should == mock_message(:request)
      
    end

    it "should build the reply using the request_message" do
      post_create
      assigns[:message].request.should == mock_message(:request)
    end

    it "should assign the reply message to @message" do
      post_create
      assigns[:message].should == mock_message(:reply)
    end

    it "should save the reply message" do
      mock_message(:reply).should_receive :save
      post_create
    end

    it "should create the message using the current user" do
      Message.should_receive(:new).with(hash_including(:user => mock_user)).and_return(mock_message(:reply))
      post_create
    end

    it "should create the message as an outgoing message" do
      Message.should_receive(:new).with(hash_including(:incoming => false)).and_return(mock_message(:reply))
      post_create
    end

    it "should authorize examination of the request message" do
      expect_authorize :examine, mock_message(:request)
      post_create
    end

    it "should authorize creation of the reply message" do
      expect_authorize :create, mock_message(:reply)
      post_create
    end

    describe "on success" do
      before(:each) do
        mock_message(:reply).stub :save => true
      end
      
      it "should render the @message as xml" do
        subject.should_receive(:render).with(hash_including(:xml => "<xml/>"))
        post_create
      end

      it "should render the @message unscrubbed because the use has created it anyways" do
        mock_message(:reply).should_receive(:to_xml).with(hash_including(:scrub => false))
        post_create
      end

      it "should render the @message as local xml because it's in the rest interface." do
        mock_message(:reply).should_receive(:to_xml).with(hash_including(:local => true))
        post_create
      end

    end

    describe "on failure" do
      before(:each) do
        mock_message(:reply).stub :save => false, :errors => 'whoeps'
      end
      
      it "should render the @message as xml" do
        subject.should_receive(:render).with(hash_including(:xml => 'whoeps'))
        post_create
      end
    end

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
