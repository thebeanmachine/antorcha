require 'spec_helper'

describe ReceptionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/receptions" }.should route_to(:controller => "receptions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/receptions/new" }.should route_to(:controller => "receptions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/receptions/1" }.should route_to(:controller => "receptions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/receptions/1/edit" }.should route_to(:controller => "receptions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/receptions" }.should route_to(:controller => "receptions", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/receptions/1" }.should route_to(:controller => "receptions", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/receptions/1" }.should route_to(:controller => "receptions", :action => "destroy", :id => "1") 
    end
  end
end
