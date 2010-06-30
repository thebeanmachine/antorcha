require 'spec_helper'

describe TransactionRolesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/transaction_roles" }.should route_to(:controller => "transaction_roles", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/transaction_roles/new" }.should route_to(:controller => "transaction_roles", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/transaction_roles/1" }.should route_to(:controller => "transaction_roles", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/transaction_roles/1/edit" }.should route_to(:controller => "transaction_roles", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/transaction_roles" }.should route_to(:controller => "transaction_roles", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/transaction_roles/1" }.should route_to(:controller => "transaction_roles", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/transaction_roles/1" }.should route_to(:controller => "transaction_roles", :action => "destroy", :id => "1") 
    end
  end
end
