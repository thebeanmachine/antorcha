require 'spec_helper'

describe DefinitionsController do
  
  before(:each) do
    act_as :advisor
  end

  def mock_definition(stubs={})
    @mock_definition ||= mock_model(Definition, stubs)
  end

  describe "GET index" do
    it "assigns all definitions as @definitions" do
      Definition.stub(:find).with(:all).and_return([mock_definition])
      get :index
      assigns[:definitions].should == [mock_definition]
    end
  end

  describe "GET show" do
    def stub_show
      stub_find(mock_definition)
      mock_definition.stub(:steps => mock_steps)
    end
    
    it "assigns the requested definition as @definition" do
      stub_show
      get :show, :id => mock_definition.to_param
      assigns[:definition].should == mock_definition
    end

    it "assigns the requested definition steps as @steps" do
      stub_show
      get :show, :id => mock_definition.to_param
      assigns[:steps].should == mock_steps
    end

  end

  describe "GET new" do
    it "assigns a new definition as @definition" do
      Definition.stub(:new).and_return(mock_definition)
      get :new
      assigns[:definition].should equal(mock_definition)
    end
  end

  describe "GET edit" do
    it "assigns the requested definition as @definition" do
      Definition.stub(:find).with("37").and_return(mock_definition)
      get :edit, :id => "37"
      assigns[:definition].should equal(mock_definition)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created definition as @definition" do
        Definition.stub(:new).with({'these' => 'params'}).and_return(mock_definition(:save => true))
        post :create, :definition => {:these => 'params'}
        assigns[:definition].should equal(mock_definition)
      end

      it "redirects to the created definition" do
        Definition.stub(:new).and_return(mock_definition(:save => true))
        post :create, :definition => {}
        response.should redirect_to(definition_url(mock_definition))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved definition as @definition" do
        Definition.stub(:new).with({'these' => 'params'}).and_return(mock_definition(:save => false))
        post :create, :definition => {:these => 'params'}
        assigns[:definition].should equal(mock_definition)
      end

      it "re-renders the 'new' template" do
        Definition.stub(:new).and_return(mock_definition(:save => false))
        post :create, :definition => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested definition" do
        Definition.should_receive(:find).with("37").and_return(mock_definition)
        mock_definition.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :definition => {:these => 'params'}
      end

      it "assigns the requested definition as @definition" do
        Definition.stub(:find).and_return(mock_definition(:update_attributes => true))
        put :update, :id => "1"
        assigns[:definition].should equal(mock_definition)
      end

      it "redirects to the definition" do
        Definition.stub(:find).and_return(mock_definition(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(definition_url(mock_definition))
      end
    end

    describe "with invalid params" do
      it "updates the requested definition" do
        Definition.should_receive(:find).with("37").and_return(mock_definition)
        mock_definition.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :definition => {:these => 'params'}
      end

      it "assigns the definition as @definition" do
        Definition.stub(:find).and_return(mock_definition(:update_attributes => false))
        put :update, :id => "1"
        assigns[:definition].should equal(mock_definition)
      end

      it "re-renders the 'edit' template" do
        Definition.stub(:find).and_return(mock_definition(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested definition" do
      Definition.should_receive(:find).with("37").and_return(mock_definition)
      mock_definition.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the definitions list" do
      Definition.stub(:find).and_return(mock_definition(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(definitions_url)
    end
  end

end
