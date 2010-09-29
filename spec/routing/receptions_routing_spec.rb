require 'spec_helper'

describe ReceptionsController do
  describe "routing" do
    it "recognizes and generates #index to give a quick index over the incoming receptions" do
      { :get => "/receptions" }.should route_to(:controller => "receptions", :action => "index")
    end

    it "recognizes and generates #show to view one single reception" do
      { :get => "/receptions/1" }.should route_to(:controller => "receptions", :action => "show", :id => "1")
    end

    it "recognizes and generates #create route to receive message deliveries" do
      { :post => "/organizations/4/receptions" }.should route_to(:controller => "receptions", :action => "create", :organization_id => '4') 
    end
  end
end
