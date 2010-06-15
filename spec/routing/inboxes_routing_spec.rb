require 'spec_helper'

describe InboxesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/inboxes" }.should route_to(:controller => "inboxes", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/inboxes/new" }.should route_to(:controller => "inboxes", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/inboxes/1" }.should route_to(:controller => "inboxes", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/inboxes/1/edit" }.should route_to(:controller => "inboxes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/inboxes" }.should route_to(:controller => "inboxes", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/inboxes/1" }.should route_to(:controller => "inboxes", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/inboxes/1" }.should route_to(:controller => "inboxes", :action => "destroy", :id => "1") 
    end
  end
end
