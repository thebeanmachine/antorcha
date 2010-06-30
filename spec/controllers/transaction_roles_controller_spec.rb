require 'spec_helper'

describe TransactionRolesController do

  def mock_transaction_role(stubs={})
    @mock_transaction_role ||= mock_model(TransactionRole, stubs)
  end

  describe "GET index" do
    it "assigns all transaction_roles as @transaction_roles" do
      TransactionRole.stub(:find).with(:all).and_return([mock_transaction_role])
      get :index
      assigns[:transaction_roles].should == [mock_transaction_role]
    end
  end

  describe "GET show" do
    it "assigns the requested transaction_role as @transaction_role" do
      TransactionRole.stub(:find).with("37").and_return(mock_transaction_role)
      get :show, :id => "37"
      assigns[:transaction_role].should equal(mock_transaction_role)
    end
  end

  describe "GET new" do
    it "assigns a new transaction_role as @transaction_role" do
      TransactionRole.stub(:new).and_return(mock_transaction_role)
      get :new
      assigns[:transaction_role].should equal(mock_transaction_role)
    end
  end

  describe "GET edit" do
    it "assigns the requested transaction_role as @transaction_role" do
      TransactionRole.stub(:find).with("37").and_return(mock_transaction_role)
      get :edit, :id => "37"
      assigns[:transaction_role].should equal(mock_transaction_role)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created transaction_role as @transaction_role" do
        TransactionRole.stub(:new).with({'these' => 'params'}).and_return(mock_transaction_role(:save => true))
        post :create, :transaction_role => {:these => 'params'}
        assigns[:transaction_role].should equal(mock_transaction_role)
      end

      it "redirects to the created transaction_role" do
        TransactionRole.stub(:new).and_return(mock_transaction_role(:save => true))
        post :create, :transaction_role => {}
        response.should redirect_to(transaction_role_url(mock_transaction_role))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved transaction_role as @transaction_role" do
        TransactionRole.stub(:new).with({'these' => 'params'}).and_return(mock_transaction_role(:save => false))
        post :create, :transaction_role => {:these => 'params'}
        assigns[:transaction_role].should equal(mock_transaction_role)
      end

      it "re-renders the 'new' template" do
        TransactionRole.stub(:new).and_return(mock_transaction_role(:save => false))
        post :create, :transaction_role => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested transaction_role" do
        TransactionRole.should_receive(:find).with("37").and_return(mock_transaction_role)
        mock_transaction_role.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :transaction_role => {:these => 'params'}
      end

      it "assigns the requested transaction_role as @transaction_role" do
        TransactionRole.stub(:find).and_return(mock_transaction_role(:update_attributes => true))
        put :update, :id => "1"
        assigns[:transaction_role].should equal(mock_transaction_role)
      end

      it "redirects to the transaction_role" do
        TransactionRole.stub(:find).and_return(mock_transaction_role(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(transaction_role_url(mock_transaction_role))
      end
    end

    describe "with invalid params" do
      it "updates the requested transaction_role" do
        TransactionRole.should_receive(:find).with("37").and_return(mock_transaction_role)
        mock_transaction_role.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :transaction_role => {:these => 'params'}
      end

      it "assigns the transaction_role as @transaction_role" do
        TransactionRole.stub(:find).and_return(mock_transaction_role(:update_attributes => false))
        put :update, :id => "1"
        assigns[:transaction_role].should equal(mock_transaction_role)
      end

      it "re-renders the 'edit' template" do
        TransactionRole.stub(:find).and_return(mock_transaction_role(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested transaction_role" do
      TransactionRole.should_receive(:find).with("37").and_return(mock_transaction_role)
      mock_transaction_role.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the transaction_roles list" do
      TransactionRole.stub(:find).and_return(mock_transaction_role(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(transaction_roles_url)
    end
  end

end
