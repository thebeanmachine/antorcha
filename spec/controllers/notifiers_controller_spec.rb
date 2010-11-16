require 'spec_helper'

describe NotifiersController do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }


  def mock_notifier(stubs={})
    @mock_notifier ||= mock_model(Notifier, stubs)
  end

  describe "GET index" do
    it "assigns all notifiers as @notifiers" do
      Notifier.stub(:find).with(:all).and_return([mock_notifier])
      get :index
      assigns[:notifiers].should == [mock_notifier]
    end
  end

  describe "GET show" do
    it "assigns the requested notifier as @notifier" do
      Notifier.stub(:find).with("37").and_return(mock_notifier)
      get :show, :id => "37"
      assigns[:notifier].should equal(mock_notifier)
    end
  end

  describe "GET new" do
    it "assigns a new notifier as @notifier" do
      Notifier.stub(:new).and_return(mock_notifier)
      get :new
      assigns[:notifier].should equal(mock_notifier)
    end
  end

  describe "GET edit" do
    it "assigns the requested notifier as @notifier" do
      Notifier.stub(:find).with("37").and_return(mock_notifier)
      get :edit, :id => "37"
      assigns[:notifier].should equal(mock_notifier)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created notifier as @notifier" do
        Notifier.stub(:new).with({'these' => 'params'}).and_return(mock_notifier(:save => true))
        post :create, :notifier => {:these => 'params'}
        assigns[:notifier].should equal(mock_notifier)
      end

      it "redirects to the created notifier" do
        Notifier.stub(:new).and_return(mock_notifier(:save => true))
        post :create, :notifier => {}
        response.should redirect_to(notifier_url(mock_notifier))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved notifier as @notifier" do
        Notifier.stub(:new).with({'these' => 'params'}).and_return(mock_notifier(:save => false))
        post :create, :notifier => {:these => 'params'}
        assigns[:notifier].should equal(mock_notifier)
      end

      it "re-renders the 'new' template" do
        Notifier.stub(:new).and_return(mock_notifier(:save => false))
        post :create, :notifier => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested notifier" do
        Notifier.should_receive(:find).with("37").and_return(mock_notifier)
        mock_notifier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :notifier => {:these => 'params'}
      end

      it "assigns the requested notifier as @notifier" do
        Notifier.stub(:find).and_return(mock_notifier(:update_attributes => true))
        put :update, :id => "1"
        assigns[:notifier].should equal(mock_notifier)
      end

      it "redirects to the notifier" do
        Notifier.stub(:find).and_return(mock_notifier(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(notifier_url(mock_notifier))
      end
    end

    describe "with invalid params" do
      it "updates the requested notifier" do
        Notifier.should_receive(:find).with("37").and_return(mock_notifier)
        mock_notifier.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :notifier => {:these => 'params'}
      end

      it "assigns the notifier as @notifier" do
        Notifier.stub(:find).and_return(mock_notifier(:update_attributes => false))
        put :update, :id => "1"
        assigns[:notifier].should equal(mock_notifier)
      end

      it "re-renders the 'edit' template" do
        Notifier.stub(:find).and_return(mock_notifier(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested notifier" do
      Notifier.should_receive(:find).with("37").and_return(mock_notifier)
      mock_notifier.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the notifiers list" do
      Notifier.stub(:find).and_return(mock_notifier(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(notifiers_url)
    end
  end

end
