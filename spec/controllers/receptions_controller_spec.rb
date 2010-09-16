require 'spec_helper'

describe ReceptionsController do

  def mock_reception(stubs={})
    @mock_reception ||= mock_model(Reception, stubs)
  end

  describe "GET index" do
    it "assigns all receptions as @receptions" do
      Reception.stub(:find).with(:all).and_return([mock_reception])
      get :index
      assigns[:receptions].should == [mock_reception]
    end
  end

  describe "GET show" do
    it "assigns the requested reception as @reception" do
      Reception.stub(:find).with("37").and_return(mock_reception)
      get :show, :id => "37"
      assigns[:reception].should equal(mock_reception)
    end
  end

  describe "GET new" do
    it "assigns a new reception as @reception" do
      Reception.stub(:new).and_return(mock_reception)
      get :new
      assigns[:reception].should equal(mock_reception)
    end
  end

  describe "GET edit" do
    it "assigns the requested reception as @reception" do
      Reception.stub(:find).with("37").and_return(mock_reception)
      get :edit, :id => "37"
      assigns[:reception].should equal(mock_reception)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created reception as @reception" do
        Reception.stub(:new).with({'these' => 'params'}).and_return(mock_reception(:save => true))
        post :create, :reception => {:these => 'params'}
        assigns[:reception].should equal(mock_reception)
      end

      it "redirects to the created reception" do
        Reception.stub(:new).and_return(mock_reception(:save => true))
        post :create, :reception => {}
        response.should redirect_to(reception_url(mock_reception))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reception as @reception" do
        Reception.stub(:new).with({'these' => 'params'}).and_return(mock_reception(:save => false))
        post :create, :reception => {:these => 'params'}
        assigns[:reception].should equal(mock_reception)
      end

      it "re-renders the 'new' template" do
        Reception.stub(:new).and_return(mock_reception(:save => false))
        post :create, :reception => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested reception" do
        Reception.should_receive(:find).with("37").and_return(mock_reception)
        mock_reception.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :reception => {:these => 'params'}
      end

      it "assigns the requested reception as @reception" do
        Reception.stub(:find).and_return(mock_reception(:update_attributes => true))
        put :update, :id => "1"
        assigns[:reception].should equal(mock_reception)
      end

      it "redirects to the reception" do
        Reception.stub(:find).and_return(mock_reception(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(reception_url(mock_reception))
      end
    end

    describe "with invalid params" do
      it "updates the requested reception" do
        Reception.should_receive(:find).with("37").and_return(mock_reception)
        mock_reception.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :reception => {:these => 'params'}
      end

      it "assigns the reception as @reception" do
        Reception.stub(:find).and_return(mock_reception(:update_attributes => false))
        put :update, :id => "1"
        assigns[:reception].should equal(mock_reception)
      end

      it "re-renders the 'edit' template" do
        Reception.stub(:find).and_return(mock_reception(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested reception" do
      Reception.should_receive(:find).with("37").and_return(mock_reception)
      mock_reception.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the receptions list" do
      Reception.stub(:find).and_return(mock_reception(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(receptions_url)
    end
  end

end
