require 'spec_helper'

describe IdentitiesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/identities" }.should route_to(:controller => "identities", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/identities/new" }.should route_to(:controller => "identities", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/identities/1" }.should route_to(:controller => "identities", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/identities/1/edit" }.should route_to(:controller => "identities", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/identities" }.should route_to(:controller => "identities", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/identities/1" }.should route_to(:controller => "identities", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/identities/1" }.should route_to(:controller => "identities", :action => "destroy", :id => "1") 
    end
  end
end
