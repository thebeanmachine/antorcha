require 'spec_helper'

describe ItemsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "inboxes/1/items" }.should route_to(:controller => "items", :action => "index", :inbox_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "inboxes/1/items/new" }.should route_to(:controller => "items", :action => "new", :inbox_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "inboxes/1/items/1" }.should route_to(:controller => "items", :action => "show", :id => "1" , :inbox_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "inboxes/1/items/1/edit" }.should route_to(:controller => "items", :action => "edit", :id => "1", :inbox_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "inboxes/1/items" }.should route_to(:controller => "items", :action => "create", :inbox_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "inboxes/1/items/1" }.should route_to(:controller => "items", :action => "update", :id => "1", :inbox_id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "inboxes/1/items/1" }.should route_to(:controller => "items", :action => "destroy", :id => "1", :inbox_id => "1") 
    end
  end
end
