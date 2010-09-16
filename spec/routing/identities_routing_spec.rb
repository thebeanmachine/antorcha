require 'spec_helper'

describe IdentitiesController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/identity/new" }.should route_to(:controller => "identities", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/identity" }.should route_to(:controller => "identities", :action => "show")
    end

    it "recognizes and generates #create" do
      { :post => "/identity" }.should route_to(:controller => "identities", :action => "create") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/identity" }.should route_to(:controller => "identities", :action => "destroy") 
    end
  end
end
