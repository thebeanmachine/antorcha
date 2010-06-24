require 'spec_helper'

describe DefinitionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/definitions" }.should route_to(:controller => "definitions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/definitions/new" }.should route_to(:controller => "definitions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/definitions/1" }.should route_to(:controller => "definitions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/definitions/1/edit" }.should route_to(:controller => "definitions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/definitions" }.should route_to(:controller => "definitions", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/definitions/1" }.should route_to(:controller => "definitions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/definitions/1" }.should route_to(:controller => "definitions", :action => "destroy", :id => "1") 
    end
  end
end
