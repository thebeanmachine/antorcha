require 'spec_helper'

describe ReactionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/reactions" }.should route_to(:controller => "reactions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/reactions/new" }.should route_to(:controller => "reactions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/reactions/1" }.should route_to(:controller => "reactions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/reactions/1/edit" }.should route_to(:controller => "reactions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/reactions" }.should route_to(:controller => "reactions", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/reactions/1" }.should route_to(:controller => "reactions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/reactions/1" }.should route_to(:controller => "reactions", :action => "destroy", :id => "1") 
    end
  end
end
