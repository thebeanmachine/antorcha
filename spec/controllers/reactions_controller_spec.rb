require 'spec_helper'

describe ReactionsController do

  def mock_reaction(stubs={})
    @mock_reaction ||= mock_model(Reaction, stubs)
  end

  describe "GET index" do
    it "assigns all reactions as @reactions" do
      Reaction.stub(:find).with(:all).and_return([mock_reaction])
      get :index
      assigns[:reactions].should == [mock_reaction]
    end
  end

  describe "GET show" do
    it "assigns the requested reaction as @reaction" do
      Reaction.stub(:find).with("37").and_return(mock_reaction)
      get :show, :id => "37"
      assigns[:reaction].should equal(mock_reaction)
    end
  end

  describe "GET new" do
    it "assigns a new reaction as @reaction" do
      Reaction.stub(:new).and_return(mock_reaction)
      get :new
      assigns[:reaction].should equal(mock_reaction)
    end
  end

  describe "GET edit" do
    it "assigns the requested reaction as @reaction" do
      Reaction.stub(:find).with("37").and_return(mock_reaction)
      get :edit, :id => "37"
      assigns[:reaction].should equal(mock_reaction)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created reaction as @reaction" do
        Reaction.stub(:new).with({'these' => 'params'}).and_return(mock_reaction(:save => true))
        post :create, :reaction => {:these => 'params'}
        assigns[:reaction].should equal(mock_reaction)
      end

      it "redirects to the created reaction" do
        Reaction.stub(:new).and_return(mock_reaction(:save => true))
        post :create, :reaction => {}
        response.should redirect_to(reaction_url(mock_reaction))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reaction as @reaction" do
        Reaction.stub(:new).with({'these' => 'params'}).and_return(mock_reaction(:save => false))
        post :create, :reaction => {:these => 'params'}
        assigns[:reaction].should equal(mock_reaction)
      end

      it "re-renders the 'new' template" do
        Reaction.stub(:new).and_return(mock_reaction(:save => false))
        post :create, :reaction => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested reaction" do
        Reaction.should_receive(:find).with("37").and_return(mock_reaction)
        mock_reaction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :reaction => {:these => 'params'}
      end

      it "assigns the requested reaction as @reaction" do
        Reaction.stub(:find).and_return(mock_reaction(:update_attributes => true))
        put :update, :id => "1"
        assigns[:reaction].should equal(mock_reaction)
      end

      it "redirects to the reaction" do
        Reaction.stub(:find).and_return(mock_reaction(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(reaction_url(mock_reaction))
      end
    end

    describe "with invalid params" do
      it "updates the requested reaction" do
        Reaction.should_receive(:find).with("37").and_return(mock_reaction)
        mock_reaction.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :reaction => {:these => 'params'}
      end

      it "assigns the reaction as @reaction" do
        Reaction.stub(:find).and_return(mock_reaction(:update_attributes => false))
        put :update, :id => "1"
        assigns[:reaction].should equal(mock_reaction)
      end

      it "re-renders the 'edit' template" do
        Reaction.stub(:find).and_return(mock_reaction(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested reaction" do
      Reaction.should_receive(:find).with("37").and_return(mock_reaction)
      mock_reaction.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the reactions list" do
      Reaction.stub(:find).and_return(mock_reaction(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(reactions_url)
    end
  end

end
