require 'spec_helper'

describe IdentitiesController do
  before(:each) do
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  describe "GET show" do
    it "assigns the requested identity as @identity" do
      Identity.stub :first => mock_identity
      get :show
      assigns[:identity].should equal(mock_identity)
    end
    
    it "authorizes showing the identity" do
      Identity.stub :first => mock_identity
      controller.should_receive(:authorize!).with(:show, mock_identity)
      get :show
    end
  end

  describe "GET new" do
    it "assigns a new identity as @identity" do
      Identity.stub(:new).and_return(mock_identity)
      get :new
      assigns[:identity].should equal(mock_identity)
    end

    it "authorizes new page of identity" do
      Identity.stub(:new).and_return(mock_identity)
      controller.should_receive(:authorize!).with(:new, mock_identity)
      get :new
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        mock_identity.stub :save => true
        Identity.stub(:new).with({'these' => 'params'}).and_return(mock_identity)
      end
      
      it "authorizes creation of identity" do
        controller.should_receive(:authorize!).with(:create, mock_identity)
        post :create, :identity => {:these => 'params'}
      end
      
      it "assigns a newly created identity as @identity" do
        post :create, :identity => {:these => 'params'}
        assigns[:identity].should equal(mock_identity)
      end

      it "redirects to the created identity" do
        post :create, :identity => {:these => 'params'}
        response.should redirect_to(identity_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_identity.stub :save => false
        Identity.stub(:new).with({'these' => 'params'}).and_return(mock_identity)
      end      
      
      it "authorizes creation of identity" do
        controller.should_receive(:authorize!).with(:create, mock_identity)
        post :create, :identity => {:these => 'params'}
      end
      
      it "assigns a newly created but unsaved identity as @identity" do
        post :create, :identity => {:these => 'params'}
        assigns[:identity].should equal(mock_identity)
      end

      it "re-renders the 'new' template" do
        post :create, :identity => {:these => 'params'}
        response.should render_template('new')
      end
    end

  end

  describe "DELETE destroy" do
    before(:each) do
      Identity.stub :first => mock_identity
      mock_identity.stub :destroy => true
    end
    
    it "destroys the requested identity" do
      mock_identity.should_receive(:destroy)
      delete :destroy
    end

    it "redirects to the identities list" do
      delete :destroy
      response.should redirect_to(identity_url)
    end
    
    it "authorizes destroy identity" do
      controller.should_receive(:authorize!).with(:destroy, mock_identity)
      delete :destroy
    end
  end

end
