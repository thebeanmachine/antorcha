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

      it "should show ourself" do
        Identity.stub(:first!).and_return(mock_model(Identity))
        mock_model(Identity).stub(:organization).and_return(mock_model(Organization))
        Organization.stub(:ourself).and_return(mock_model(Organization))    
      end
    end
  end

end
