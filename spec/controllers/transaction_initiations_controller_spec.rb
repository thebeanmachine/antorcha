require 'spec_helper'

describe TransactionInitiationsController do
  
  before(:each) do
    sign_in_user :communicator, :as => :hulpverlener
  end
  
  def stub_find_starting_steps
    Step.stub :starting_steps => mock_steps
  end
  
  describe "GET new" do
    it "should assign starting steps as @starting_steps" do
      stub_find_starting_steps
      get :new
      assigns[:starting_steps].should == mock_steps
    end
  end

  describe "POST create" do
    
    def stub_successful_create
      stub_find_step
      stub_validation_successful
      stub_create_transaction
      stub_build_message

      stub_find_starting_steps
    end

    def stub_unsuccessful_create
      stub_find_step
      stub_validation_successful false
      stub_find_starting_steps
    end
    
    def stub_validation_successful success = true
      mock_transaction.stub :validate_initiation => nil
      mock_transaction.errors.stub :blank? => success
    end

    def stub_create_transaction
      stub_new(mock_transaction)

      mock_transaction.stub \
        :definition= => nil,
        :save => true,
        :update_uri => nil

      mock_step.stub :definition => mock_definition
    end

    def stub_find_step
      stub_find(mock_step)
      mock_transaction.stub :starting_step => mock_step.to_param
    end
    
    def stub_build_message
      mock_transaction.stub :messages => mock_messages
      stub_build_on mock_messages, mock_message
      mock_message.stub :save => true
    end

    describe "when invalid" do
      it "should redirect to new action" do
        stub_unsuccessful_create
        get :create
        response.should render_template('new')
      end

      it "should assign starting steps as @starting_steps" do
        stub_unsuccessful_create
        get :create
        assigns[:starting_steps].should == mock_steps
      end
    end

    describe "when successful" do
      it "should assign definition of step to transaction" do
        stub_successful_create
        mock_transaction.should_receive(:definition=).with(mock_definition)
        get :create
      end

      it "should assign unique uri to transaction" do
        stub_successful_create
        mock_transaction.should_receive(:update_uri).with(transaction_url(mock_transaction))
        get :create
      end
    
      it "should redirect to the edit screen of created message" do
        stub_successful_create
        get :create
        response.should redirect_to(edit_message_url(mock_message))
      end
      
      it "should flash successful message" do
        stub_successful_create
        get :create
        flash[:notice].should =~ /Transactie succesvol aangemaakt/
      end
    end
  end
end
