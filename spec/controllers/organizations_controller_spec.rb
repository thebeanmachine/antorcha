require 'spec_helper'

describe OrganizationsController, "for ReST interface" do

  before(:each) do    
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  it "should use OrganizationsController" do
    controller.should be_an_instance_of(OrganizationsController)
  end

  describe "GET 'index'" do
    it "should be successful" do
      stub_all mock_organizations
      mock_organizations.stub :to_xml => "<organizations/>"

      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      stub_find mock_organization
      mock_organization.stub :to_xml => "<organizations/>"

      get 'show', :id => mock_organization.to_param
      response.should be_success
    end
  end
end
