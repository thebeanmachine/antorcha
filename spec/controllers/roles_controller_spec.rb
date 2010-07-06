require 'spec_helper'

describe RolesController do

  before(:each) do
    act_as :advisor
  end

  def stub_load_and_authorize_resource
    stub_find mock_definition
    mock_definition.stub :roles => mock_roles
    stub_find_on mock_roles, mock_role

    stub_build_on mock_roles, mock_role, 'these' => 'params'
    stub_build_on mock_roles, mock_role
  end

  describe "GET index" do
    it "assigns all roles as @roles" do
      stub_load_and_authorize_resource
      get :index, :definition_id => mock_definition.to_param
      assigns[:roles].should == mock_roles
    end
  end

  describe "GET show" do
    it "assigns the requested role as @role" do
      stub_load_and_authorize_resource
      get :show, :definition_id => mock_definition.to_param, :id => mock_role.to_param
      assigns[:role].should equal(mock_role)
    end
  end

  describe "GET new" do
    it "assigns a new role as @role" do
      stub_load_and_authorize_resource
      get :new, :definition_id => mock_definition.to_param
      assigns[:role].should equal(mock_role)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested role as @role" do
      stub_load_and_authorize_resource
      get :edit, :definition_id => mock_definition.to_param, :id => mock_role.to_param
      assigns[:role].should equal(mock_role)
    end
  end
  
  describe "POST create" do
    def post_create
      post :create, :role => {:these => 'params'}, :definition_id => mock_definition.to_param
    end

    describe "with valid params" do
      def stub_valid_create
        stub_load_and_authorize_resource
        mock_role.stub :save => true
      end

      it "assigns a newly created role as @role" do
        stub_valid_create
        post_create
        assigns[:role].should equal(mock_role)
      end

      it "redirects to the created role" do
        stub_valid_create
        post_create
        response.should redirect_to(definition_role_url(mock_definition, mock_role))
      end
    end

    describe "with invalid params" do
      def stub_invalid_create
        stub_load_and_authorize_resource
        mock_role.stub :save => false
      end
      
      it "assigns a newly created but unsaved role as @role" do
        stub_invalid_create
        post_create
        assigns[:role].should equal(mock_role)
      end

      it "re-renders the 'new' template" do
        stub_invalid_create
        post_create
        response.should render_template('new')
      end
    end
  end

  describe "PUT update" do

    def put_update
      put :update, :id => mock_role.to_param, :role => {:these => 'params'}, :definition_id => mock_definition.to_param
    end

    describe "with valid params" do
      def stub_valid_update
        stub_load_and_authorize_resource
        mock_role.stub :update_attributes => true
      end
      
      it "updates the requested role" do
        stub_valid_update
        mock_role.should_receive(:update_attributes).with({'these' => 'params'})
        put_update
      end

      it "assigns the requested role as @role" do
        stub_valid_update
        put_update
        assigns[:role].should equal(mock_role)
      end

      it "redirects to the role" do
        stub_valid_update
        put_update
        response.should redirect_to(definition_role_url(mock_definition, mock_role))
      end
    end

    describe "with invalid params" do
      def stub_invalid_update
        stub_load_and_authorize_resource
        mock_role.stub :update_attributes => false
      end
      
      it "updates the requested role" do
        stub_invalid_update
        mock_role.should_receive(:update_attributes).with({'these' => 'params'})
        put_update
      end

      it "assigns the role as @role" do
        stub_invalid_update
        put_update
        assigns[:role].should equal(mock_role)
      end

      it "re-renders the 'edit' template" do
        stub_invalid_update
        put_update
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    def stub_destroy
      stub_load_and_authorize_resource
      mock_role.stub :destroy => true
    end
    
    def delete_destroy
      delete :destroy, :definition_id => mock_definition.to_param, :id => mock_role.to_param
    end

    it "destroys the requested role" do
      stub_destroy
      mock_role.should_receive(:destroy)
      delete_destroy
    end

    it "redirects to the roles list" do
      stub_destroy
      delete_destroy
      response.should redirect_to(definition_roles_url(mock_definition))
    end
  end
end
