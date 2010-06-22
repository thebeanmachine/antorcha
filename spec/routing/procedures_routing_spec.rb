require 'spec_helper'

describe ProceduresController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/procedures" }.should route_to(:controller => "procedures", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/procedures/new" }.should route_to(:controller => "procedures", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/procedures/1" }.should route_to(:controller => "procedures", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/procedures/1/edit" }.should route_to(:controller => "procedures", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/procedures" }.should route_to(:controller => "procedures", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/procedures/1" }.should route_to(:controller => "procedures", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/procedures/1" }.should route_to(:controller => "procedures", :action => "destroy", :id => "1") 
    end
  end
end
