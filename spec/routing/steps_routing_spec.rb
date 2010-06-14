require 'spec_helper'

describe StepsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/steps" }.should route_to(:controller => "steps", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/steps/new" }.should route_to(:controller => "steps", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/steps/1" }.should route_to(:controller => "steps", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/steps/1/edit" }.should route_to(:controller => "steps", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/steps" }.should route_to(:controller => "steps", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/steps/1" }.should route_to(:controller => "steps", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/steps/1" }.should route_to(:controller => "steps", :action => "destroy", :id => "1") 
    end
  end
end
