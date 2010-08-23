require 'spec_helper'

describe TransactionsController do

  def mock_transaction(stubs={})
    @mock_transaction ||= mock_model(Transaction, stubs)
  end

  describe "GET index" do
    it "assigns all transactions as @transactions" do
      sign_in_user :maintainer
      Transaction.stub(:find).with(:all).and_return([mock_transaction])
      get :index
      assigns[:transactions].should == [mock_transaction]
    end
  end

  describe "GET show" do
    it "assigns the requested transaction as @transaction" do
      sign_in_user :communicator
      Transaction.stub(:find).with("37").and_return(mock_transaction)
      get :show, :id => "37"
      assigns[:transaction].should equal(mock_transaction)
    end
  end

  describe "GET new" do
    before(:each) do
      sign_in_user :communicator
    end
    def stub_get_new
      Transaction.stub(:new).and_return(mock_transaction)
      stub_all mock_definition
    end
    
    it "assigns a new transaction as @transaction" do
      stub_get_new
      get :new
      assigns[:transaction].should equal(mock_transaction)
    end

    it "assigns all selectable definitions as @definitions" do
      stub_get_new
      get :new
      assigns[:definitions].should == [mock_definition]
    end

  end

  describe "GET edit" do
    it "assigns the requested transaction as @transaction" do
      Transaction.stub(:find).with("37").and_return(mock_transaction)
      get :edit, :id => "37"
      assigns[:transaction].should equal(nil)
    end
  end

  describe "POST create" do
    before(:each) do
      sign_in_user :communicator
    end
    describe "with valid params" do
              
      def stub_successful_create
        stub_new(mock_transaction, {'these' => 'params'})
        stub_successful_save_for(mock_transaction)
        mock_transaction.stub(:update_uri => true)
      end
      
      def post_create
        post :create, :transaction => {:these => 'params'}
      end

      it "assigns a newly created transaction as @transaction" do
        stub_successful_create
        post_create
        assigns[:transaction].should equal(mock_transaction)
      end

      it "assigns unique uri for transaction" do
        stub_successful_create
        mock_transaction.should_receive(:update_uri).with(controller.url_for(mock_transaction))
        post_create
      end

      it "redirects to the created transaction" do
        stub_successful_create
        post_create
        response.should redirect_to(transaction_url(mock_transaction))
      end
    end

    describe "with invalid params" do
      
      it "assigns a newly created but unsaved transaction as @transaction" do
        Transaction.stub(:new).with({'these' => 'params'}).and_return(mock_transaction(:save => false))
        post :create, :transaction => {:these => 'params'}
        assigns[:transaction].should equal(mock_transaction)
      end

      it "re-renders the 'new' template" do
        Transaction.stub(:new).and_return(mock_transaction(:save => false))
        post :create, :transaction => {}
        response.should render_template('new')
      end
    end

  end

  # describe "PUT update" do
  # 
  #     describe "with valid params" do
  #       it "updates the requested transaction" do
  #         Transaction.should_receive(:find).with("37").and_return(mock_transaction)
  #         mock_transaction.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :transaction => {:these => 'params'}
  #       end
  # 
  #       it "assigns the requested transaction as @transaction" do
  #         Transaction.stub(:find).and_return(mock_transaction(:update_attributes => true))
  #         put :update, :id => "1"
  #         assigns[:transaction].should equal(mock_transaction)
  #       end
  # 
  #       it "redirects to the transaction" do
  #         Transaction.stub(:find).and_return(mock_transaction(:update_attributes => true))
  #         put :update, :id => "1"
  #         response.should redirect_to(transaction_url(mock_transaction))
  #       end
  #     end
  # 
  #     describe "with invalid params" do
  #       it "updates the requested transaction" do
  #         Transaction.should_receive(:find).with("37").and_return(mock_transaction)
  #         mock_transaction.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :id => "37", :transaction => {:these => 'params'}
  #       end
  # 
  #       it "assigns the transaction as @transaction" do
  #         Transaction.stub(:find).and_return(mock_transaction(:update_attributes => false))
  #         put :update, :id => "1"
  #         assigns[:transaction].should equal(mock_transaction)
  #       end
  # 
  #       it "re-renders the 'edit' template" do
  #         Transaction.stub(:find).and_return(mock_transaction(:update_attributes => false))
  #         put :update, :id => "1"
  #         response.should render_template('edit')
  #       end
  #     end
  # 
  #   end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested transaction" do
  #     Transaction.should_receive(:find).with("37").and_return(mock_transaction)
  #     mock_transaction.should_not_receive(:destroy)
  #     #delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the transactions list" do
  #     Transaction.stub(:find).and_return(mock_transaction(:destroy => true))
  #     delete :destroy, :id => "1"
  #     response.should redirect_to(transactions_url)
  #   end
  # end

end
