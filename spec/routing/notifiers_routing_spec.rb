require 'spec_helper'

describe NotifiersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/notifiers" }.should route_to(:controller => "notifiers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/notifiers/new" }.should route_to(:controller => "notifiers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/notifiers/1" }.should route_to(:controller => "notifiers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/notifiers/1/edit" }.should route_to(:controller => "notifiers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/notifiers" }.should route_to(:controller => "notifiers", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/notifiers/1" }.should route_to(:controller => "notifiers", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/notifiers/1" }.should route_to(:controller => "notifiers", :action => "destroy", :id => "1") 
    end
  end
end
