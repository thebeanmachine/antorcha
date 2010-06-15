require 'spec_helper'

describe InboxesController do

  def mock_inbox(stubs={})
    @mock_inbox ||= mock_model(Inbox, stubs)
  end

  describe "GET index" do
    it "assigns all inboxes as @inboxes" do
      Inbox.stub(:find).with(:all).and_return([mock_inbox])
      get :index
      assigns[:inboxes].should == [mock_inbox]
    end
  end

  describe "GET show" do
    it "assigns the requested inbox as @inbox" do
      Inbox.stub(:find).with("37").and_return(mock_inbox)
      get :show, :id => "37"
      assigns[:inbox].should equal(mock_inbox)
    end
  end

  describe "GET new" do
    it "assigns a new inbox as @inbox" do
      Inbox.stub(:new).and_return(mock_inbox)
      get :new
      assigns[:inbox].should equal(mock_inbox)
    end
  end

  describe "GET edit" do
    it "assigns the requested inbox as @inbox" do
      Inbox.stub(:find).with("37").and_return(mock_inbox)
      get :edit, :id => "37"
      assigns[:inbox].should equal(mock_inbox)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created inbox as @inbox" do
        Inbox.stub(:new).with({'these' => 'params'}).and_return(mock_inbox(:save => true))
        post :create, :inbox => {:these => 'params'}
        assigns[:inbox].should equal(mock_inbox)
      end

      it "redirects to the created inbox" do
        Inbox.stub(:new).and_return(mock_inbox(:save => true))
        post :create, :inbox => {}
        response.should redirect_to(inbox_url(mock_inbox))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved inbox as @inbox" do
        Inbox.stub(:new).with({'these' => 'params'}).and_return(mock_inbox(:save => false))
        post :create, :inbox => {:these => 'params'}
        assigns[:inbox].should equal(mock_inbox)
      end

      it "re-renders the 'new' template" do
        Inbox.stub(:new).and_return(mock_inbox(:save => false))
        post :create, :inbox => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested inbox" do
        Inbox.should_receive(:find).with("37").and_return(mock_inbox)
        mock_inbox.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inbox => {:these => 'params'}
      end

      it "assigns the requested inbox as @inbox" do
        Inbox.stub(:find).and_return(mock_inbox(:update_attributes => true))
        put :update, :id => "1"
        assigns[:inbox].should equal(mock_inbox)
      end

      it "redirects to the inbox" do
        Inbox.stub(:find).and_return(mock_inbox(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(inbox_url(mock_inbox))
      end
    end

    describe "with invalid params" do
      it "updates the requested inbox" do
        Inbox.should_receive(:find).with("37").and_return(mock_inbox)
        mock_inbox.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :inbox => {:these => 'params'}
      end

      it "assigns the inbox as @inbox" do
        Inbox.stub(:find).and_return(mock_inbox(:update_attributes => false))
        put :update, :id => "1"
        assigns[:inbox].should equal(mock_inbox)
      end

      it "re-renders the 'edit' template" do
        Inbox.stub(:find).and_return(mock_inbox(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested inbox" do
      Inbox.should_receive(:find).with("37").and_return(mock_inbox)
      mock_inbox.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the inboxes list" do
      Inbox.stub(:find).and_return(mock_inbox(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(inboxes_url)
    end
  end

end
