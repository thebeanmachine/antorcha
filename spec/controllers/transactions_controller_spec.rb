require 'spec_helper'

describe TransactionsController do

  before(:each) do
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }
  
  describe "for maintainers" do

    describe "GET index" do
      before(:each) do
        stub_search mock_transactions
        stub_all mock_organizations
        mock_search.stub :organization_ids => [mock_organization.to_param]
      end
    
      it "should authorize :index, Transactions" do
        controller.should_receive(:authorize!).with(:index, Transaction)
        get :index
      end
    
      it "assigns searched transactions as @transactions" do
        get :index
        assigns[:transactions].should == mock_transactions
      end

      it "assigns all organizations as @organizations" do
        get :index
        assigns[:organizations].should == mock_organizations
      end

      it "assigns all filtered organizations as @filtered_organizations" do
        get :index
        assigns[:filtered_organizations].should == mock_organizations
      end

      it "assigns nil to @filtered_organizations if there are none filtered organizations" do
        mock_search.stub :organization_ids => []
        get :index
        assigns[:filtered_organizations].should == []
      end

    end

    describe "GET show" do
      it "assigns the requested transaction as @transaction" do
        Transaction.stub(:find).with("37").and_return(mock_transaction)
        get :show, :id => "37"
        assigns[:transaction].should equal(mock_transaction)
      end
    end
  end

  describe "for communicators" do
    describe "GET new" do
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

    describe "POST create" do
      describe "with valid params" do
        def stub_successful_create
          stub_new(mock_transaction, {'these' => 'params'})
          mock_transaction.stub :save => true, :update_uri => true
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
        before(:each) do
          mock_transaction.stub :save => false
          stub_new mock_transaction, {'these' => 'params'}
        end
      
        it "assigns a newly created but unsaved transaction as @transaction" do
          post :create, :transaction => {:these => 'params'}
          assigns[:transaction].should equal(mock_transaction)
        end

        it "re-renders the 'new' template" do
          post :create, :transaction => {:these => 'params'}
          response.should render_template('new')
        end
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
