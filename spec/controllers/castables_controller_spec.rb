require 'spec_helper'

describe CastablesController do

  def mock_castable(stubs={})
    @mock_castable ||= mock_model(Castable, stubs)
  end

  describe "GET index" do
    it "assigns all castables as @castables" do
      Castable.stub(:find).with(:all).and_return([mock_castable])
      get :index
      assigns[:castables].should == [mock_castable]
    end
  end

  describe "GET show" do
    it "assigns the requested castable as @castable" do
      Castable.stub(:find).with("37").and_return(mock_castable)
      get :show, :id => "37"
      assigns[:castable].should equal(mock_castable)
    end
  end

  describe "GET new" do
    it "assigns a new castable as @castable" do
      Castable.stub(:new).and_return(mock_castable)
      get :new
      assigns[:castable].should equal(mock_castable)
    end
  end

  describe "GET edit" do
    it "assigns the requested castable as @castable" do
      Castable.stub(:find).with("37").and_return(mock_castable)
      get :edit, :id => "37"
      assigns[:castable].should equal(mock_castable)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created castable as @castable" do
        Castable.stub(:new).with({'these' => 'params'}).and_return(mock_castable(:save => true))
        post :create, :castable => {:these => 'params'}
        assigns[:castable].should equal(mock_castable)
      end

      it "redirects to the created castable" do
        Castable.stub(:new).and_return(mock_castable(:save => true))
        post :create, :castable => {}
        response.should redirect_to(castable_url(mock_castable))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved castable as @castable" do
        Castable.stub(:new).with({'these' => 'params'}).and_return(mock_castable(:save => false))
        post :create, :castable => {:these => 'params'}
        assigns[:castable].should equal(mock_castable)
      end

      it "re-renders the 'new' template" do
        Castable.stub(:new).and_return(mock_castable(:save => false))
        post :create, :castable => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested castable" do
        Castable.should_receive(:find).with("37").and_return(mock_castable)
        mock_castable.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :castable => {:these => 'params'}
      end

      it "assigns the requested castable as @castable" do
        Castable.stub(:find).and_return(mock_castable(:update_attributes => true))
        put :update, :id => "1"
        assigns[:castable].should equal(mock_castable)
      end

      it "redirects to the castable" do
        Castable.stub(:find).and_return(mock_castable(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(castable_url(mock_castable))
      end
    end

    describe "with invalid params" do
      it "updates the requested castable" do
        Castable.should_receive(:find).with("37").and_return(mock_castable)
        mock_castable.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :castable => {:these => 'params'}
      end

      it "assigns the castable as @castable" do
        Castable.stub(:find).and_return(mock_castable(:update_attributes => false))
        put :update, :id => "1"
        assigns[:castable].should equal(mock_castable)
      end

      it "re-renders the 'edit' template" do
        Castable.stub(:find).and_return(mock_castable(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested castable" do
      Castable.should_receive(:find).with("37").and_return(mock_castable)
      mock_castable.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the castables list" do
      Castable.stub(:find).and_return(mock_castable(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(castables_url)
    end
  end

end
