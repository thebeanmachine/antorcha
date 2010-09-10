require 'spec_helper'

describe IdentitiesController do

  def mock_identity(stubs={})
    @mock_identity ||= mock_model(Identity, stubs)
  end

  describe "GET index" do
    it "assigns all identities as @identities" do
      Identity.stub(:find).with(:all).and_return([mock_identity])
      get :index
      assigns[:identities].should == [mock_identity]
    end
  end

  describe "GET show" do
    it "assigns the requested identity as @identity" do
      Identity.stub(:find).with("37").and_return(mock_identity)
      get :show, :id => "37"
      assigns[:identity].should equal(mock_identity)
    end
  end

  describe "GET new" do
    it "assigns a new identity as @identity" do
      Identity.stub(:new).and_return(mock_identity)
      get :new
      assigns[:identity].should equal(mock_identity)
    end
  end

  describe "GET edit" do
    it "assigns the requested identity as @identity" do
      Identity.stub(:find).with("37").and_return(mock_identity)
      get :edit, :id => "37"
      assigns[:identity].should equal(mock_identity)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created identity as @identity" do
        Identity.stub(:new).with({'these' => 'params'}).and_return(mock_identity(:save => true))
        post :create, :identity => {:these => 'params'}
        assigns[:identity].should equal(mock_identity)
      end

      it "redirects to the created identity" do
        Identity.stub(:new).and_return(mock_identity(:save => true))
        post :create, :identity => {}
        response.should redirect_to(identity_url(mock_identity))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved identity as @identity" do
        Identity.stub(:new).with({'these' => 'params'}).and_return(mock_identity(:save => false))
        post :create, :identity => {:these => 'params'}
        assigns[:identity].should equal(mock_identity)
      end

      it "re-renders the 'new' template" do
        Identity.stub(:new).and_return(mock_identity(:save => false))
        post :create, :identity => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested identity" do
        Identity.should_receive(:find).with("37").and_return(mock_identity)
        mock_identity.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :identity => {:these => 'params'}
      end

      it "assigns the requested identity as @identity" do
        Identity.stub(:find).and_return(mock_identity(:update_attributes => true))
        put :update, :id => "1"
        assigns[:identity].should equal(mock_identity)
      end

      it "redirects to the identity" do
        Identity.stub(:find).and_return(mock_identity(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(identity_url(mock_identity))
      end
    end

    describe "with invalid params" do
      it "updates the requested identity" do
        Identity.should_receive(:find).with("37").and_return(mock_identity)
        mock_identity.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :identity => {:these => 'params'}
      end

      it "assigns the identity as @identity" do
        Identity.stub(:find).and_return(mock_identity(:update_attributes => false))
        put :update, :id => "1"
        assigns[:identity].should equal(mock_identity)
      end

      it "re-renders the 'edit' template" do
        Identity.stub(:find).and_return(mock_identity(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested identity" do
      Identity.should_receive(:find).with("37").and_return(mock_identity)
      mock_identity.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the identities list" do
      Identity.stub(:find).and_return(mock_identity(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(identities_url)
    end
  end

end
