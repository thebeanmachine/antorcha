require 'spec_helper'

describe CastablesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/castables" }.should route_to(:controller => "castables", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/castables/new" }.should route_to(:controller => "castables", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/castables/1" }.should route_to(:controller => "castables", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/castables/1/edit" }.should route_to(:controller => "castables", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/castables" }.should route_to(:controller => "castables", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/castables/1" }.should route_to(:controller => "castables", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/castables/1" }.should route_to(:controller => "castables", :action => "destroy", :id => "1") 
    end
  end
end
