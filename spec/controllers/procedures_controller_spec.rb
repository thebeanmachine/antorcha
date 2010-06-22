require 'spec_helper'

describe ProceduresController do

  def mock_procedure(stubs={})
    @mock_procedure ||= mock_model(Procedure, stubs)
  end

  describe "GET index" do
    it "assigns all procedures as @procedures" do
      Procedure.stub(:find).with(:all).and_return([mock_procedure])
      get :index
      assigns[:procedures].should == [mock_procedure]
    end
  end

  describe "GET show" do
    def stub_show
      stub_find(mock_procedure)
      mock_procedure.stub(:instructions => mock_instructions)
    end
    
    it "assigns the requested procedure as @procedure" do
      stub_show
      get :show, :id => mock_procedure.to_param
      assigns[:procedure].should == mock_procedure
    end

    it "assigns the requested procedure instructions as @instructions" do
      stub_show
      get :show, :id => mock_procedure.to_param
      assigns[:instructions].should == mock_instructions
    end

  end

  describe "GET new" do
    it "assigns a new procedure as @procedure" do
      Procedure.stub(:new).and_return(mock_procedure)
      get :new
      assigns[:procedure].should equal(mock_procedure)
    end
  end

  describe "GET edit" do
    it "assigns the requested procedure as @procedure" do
      Procedure.stub(:find).with("37").and_return(mock_procedure)
      get :edit, :id => "37"
      assigns[:procedure].should equal(mock_procedure)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created procedure as @procedure" do
        Procedure.stub(:new).with({'these' => 'params'}).and_return(mock_procedure(:save => true))
        post :create, :procedure => {:these => 'params'}
        assigns[:procedure].should equal(mock_procedure)
      end

      it "redirects to the created procedure" do
        Procedure.stub(:new).and_return(mock_procedure(:save => true))
        post :create, :procedure => {}
        response.should redirect_to(procedure_url(mock_procedure))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved procedure as @procedure" do
        Procedure.stub(:new).with({'these' => 'params'}).and_return(mock_procedure(:save => false))
        post :create, :procedure => {:these => 'params'}
        assigns[:procedure].should equal(mock_procedure)
      end

      it "re-renders the 'new' template" do
        Procedure.stub(:new).and_return(mock_procedure(:save => false))
        post :create, :procedure => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested procedure" do
        Procedure.should_receive(:find).with("37").and_return(mock_procedure)
        mock_procedure.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :procedure => {:these => 'params'}
      end

      it "assigns the requested procedure as @procedure" do
        Procedure.stub(:find).and_return(mock_procedure(:update_attributes => true))
        put :update, :id => "1"
        assigns[:procedure].should equal(mock_procedure)
      end

      it "redirects to the procedure" do
        Procedure.stub(:find).and_return(mock_procedure(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(procedure_url(mock_procedure))
      end
    end

    describe "with invalid params" do
      it "updates the requested procedure" do
        Procedure.should_receive(:find).with("37").and_return(mock_procedure)
        mock_procedure.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :procedure => {:these => 'params'}
      end

      it "assigns the procedure as @procedure" do
        Procedure.stub(:find).and_return(mock_procedure(:update_attributes => false))
        put :update, :id => "1"
        assigns[:procedure].should equal(mock_procedure)
      end

      it "re-renders the 'edit' template" do
        Procedure.stub(:find).and_return(mock_procedure(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested procedure" do
      Procedure.should_receive(:find).with("37").and_return(mock_procedure)
      mock_procedure.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the procedures list" do
      Procedure.stub(:find).and_return(mock_procedure(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(procedures_url)
    end
  end

end
