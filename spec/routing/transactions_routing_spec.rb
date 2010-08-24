require 'spec_helper'

describe TransactionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/transactions" }.should route_to(:controller => "transactions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/transactions/new" }.should route_to(:controller => "transactions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/transactions/1" }.should route_to(:controller => "transactions", :action => "show", :id => "1")
    end

    it "does not recognize #edit" do
      { :get => "/transactions/1/edit" }.should_not be_routable #route_to(:controller => "transactions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/transactions" }.should route_to(:controller => "transactions", :action => "create") 
    end

    it "does not recognize #update" do
      { :put => "/transactions/1" }.should_not be_routable
    end

    it "does not recognize #destroy" do
      { :delete => "/transactions/1" }.should_not be_routable
    end
  end
end
