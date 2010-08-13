require 'spec_helper'

describe MessageRepliesController do
  
  before(:each) do
    sign_in_user
  end

  def stub_find_origin_message
    stub_find(mock_message(:origin))
    mock_message(:origin).stub :definition => mock_definition
    mock_message(:origin).stub :effect_steps => mock_steps
    stub_authorize!
  end

  describe "GET new" do
    def stub_new_action
      stub_find_origin_message
      stub_new(mock_message(:reply))
    end

    def get_new
      get :new, :message_id => mock_message(:origin).to_param
    end

    it "should authorize! new message" do
      stub_new_action
      expect_authorize :show, mock_message(:origin)
      expect_authorize :new, Message
      get_new
    end

    it "should assign effect steps of the origin step to @steps" do
      stub_new_action
      get_new
      assigns[:steps].should == mock_steps
    end

    it "should call effect steps of the origin step to @steps" do
      stub_new_action
      mock_message(:origin).should_receive(:effect_steps)
      get_new
    end

    it "should assign new reply message to @message" do
      stub_new_action
      get_new
      assigns[:message].should == mock_message(:reply)
    end
  end


  describe "POST create" do
    
    def stub_create_action
      stub_find_origin_message

      mock_message(:origin).stub :replies => mock_messages
      stub_build_on mock_messages, mock_message(:reply), 'aap' => :noot
    end
    
    def post_create
      post :create, :message_id => mock_message(:origin).to_param, :message => { 'aap' => :noot }
    end

    describe "successful save" do
      before(:each) do
        stub_successful_save_for(mock_message(:reply))
      end

      it "should authorize! create message" do
        stub_create_action
        expect_authorize :show, mock_message(:origin)
        expect_authorize :create, mock_message(:reply)
        post_create
      end
      
      it "should assign all steps from the definition of the message transaction to @steps" do
        stub_create_action
        post_create
        assigns[:steps].should == mock_steps
      end

      it "should assing @message to the created message" do
        stub_create_action
        post_create
        assigns[:message].should == mock_message(:reply)
      end

      it "should save the reply message" do
        stub_create_action
        mock_message(:reply).should_receive :save
        post_create
      end

      it "should flash 'succesvol aangemaakt'" do
        stub_create_action
        post_create
        flash[:notice].should =~ /Bericht was succesvol aangemaakt/
      end

      it "should redirect to @message edit" do
        stub_create_action
        post_create
        response.should redirect_to(edit_message_url(mock_message(:reply)))
      end
    end

    describe "unsuccesful save" do
      before(:each) do
        stub_unsuccessful_save_for(mock_message(:reply))
      end

      it "should render new action" do
        stub_create_action
        post_create
        should render_template 'new'
      end
    end
  end

end
