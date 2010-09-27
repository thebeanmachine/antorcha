require 'spec_helper'

describe Organization do

  it "should be specced against olympus"

  describe "resource location" do
    subject do
      Organization.new :url => 'http://example.com/messages'
    end

    describe "with identity" do
      before(:each) do
        Identity.stub :first! => mock_identity
        mock_identity.stub :organization => mock_organization
      end

      it "should format the delivery url" do
        subject.delivery_url.should == "http://example.com/organizations/#{mock_organization.to_param}/receptions"
      end
      it "should format the cancellation url" do
        subject.cancellation_url.should == 'http://example.com/transactions/cancellations'
      end
      it "should format the delivery confirmation url" do
        subject.delivery_confirmation_url(123).should == "http://example.com/organizations/#{mock_organization.to_param}/deliveries/123/confirmation"
      end
    end

  end

  # before(:each) do
  #   @valid_attributes = {
  #     :title => "value for title",
  #     :url => "value for url"
  #   }
  # end
  # 
  # it "should create a new instance given valid attributes" do
  #   Organization.create!(@valid_attributes)
  # end
  # 
  # it "should validate on title" do
  #   Organization.create()
  #   should have(1).error_on(:title)
  # end
  # 
  # describe "check polymorphic assosiations with roles" do
  #   before(:each) do
  #     @org = Factory.create(:organization)
  #   end
  #   
  #   it "should creat an role through fulfills" do    
  #     role = @org.roles.create(:title => "role1")
  #     role.should have(:no).error
  #   end
  #   
  #   it "should fail creating an role through fulfills" do
  #     role = @org.roles.create()
  #     role.should have(1).error_on(:title)
  #   end
  # end
end
