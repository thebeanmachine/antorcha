require 'spec_helper'

describe RolesController do

  def mock_role(stubs={})
    @mock_role ||= mock_model(Role, stubs)
  end

  describe "GET index" do
    it "assigns all roles as @roles" do
      Role.stub(:find).with(:all).and_return([mock_role])
      get :index
      assigns[:roles].should == [mock_role]
    end
  end

  describe "GET show" do
    it "assigns the requested role as @role" do
      Role.stub(:find).with("37").and_return(mock_role)
      get :show, :id => "37"
      assigns[:role].should equal(mock_role)
    end
  end

  describe "GET new" do
    it "assigns a new role as @role" do
      Role.stub(:new).and_return(mock_role)
      get :new
      assigns[:role].should equal(mock_role)
    end
  end

  describe "GET edit" do
    it "assigns the requested role as @role" do
      Role.stub(:find).with("37").and_return(mock_role)
      get :edit, :id => "37"
      assigns[:role].should equal(mock_role)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created role as @role" do
        Role.stub(:new).with({'these' => 'params'}).and_return(mock_role(:save => true))
        post :create, :role => {:these => 'params'}
        assigns[:role].should equal(mock_role)
      end

      it "redirects to the created role" do
        Role.stub(:new).and_return(mock_role(:save => true))
        post :create, :role => {}
        response.should redirect_to(role_url(mock_role))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved role as @role" do
        Role.stub(:new).with({'these' => 'params'}).and_return(mock_role(:save => false))
        post :create, :role => {:these => 'params'}
        assigns[:role].should equal(mock_role)
      end

      it "re-renders the 'new' template" do
        Role.stub(:new).and_return(mock_role(:save => false))
        post :create, :role => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested role" do
        Role.should_receive(:find).with("37").and_return(mock_role)
        mock_role.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :role => {:these => 'params'}
      end

      it "assigns the requested role as @role" do
        Role.stub(:find).and_return(mock_role(:update_attributes => true))
        put :update, :id => "1"
        assigns[:role].should equal(mock_role)
      end

      it "redirects to the role" do
        Role.stub(:find).and_return(mock_role(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(role_url(mock_role))
      end
    end

    describe "with invalid params" do
      it "updates the requested role" do
        Role.should_receive(:find).with("37").and_return(mock_role)
        mock_role.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :role => {:these => 'params'}
      end

      it "assigns the role as @role" do
        Role.stub(:find).and_return(mock_role(:update_attributes => false))
        put :update, :id => "1"
        assigns[:role].should equal(mock_role)
      end

      it "re-renders the 'edit' template" do
        Role.stub(:find).and_return(mock_role(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested role" do
      Role.should_receive(:find).with("37").and_return(mock_role)
      mock_role.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the roles list" do
      Role.stub(:find).and_return(mock_role(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(roles_url)
    end
  end

end
