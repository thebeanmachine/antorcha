require 'spec_helper'

describe TransactionRole do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    TransactionRole.create!(@valid_attributes)
  end
  
  describe "check polymorphic assosiations with organizations" do
    before(:each) do
      @role = Factory.create(:transaction_role)
    end
    
    it "should create an organization through fulfills" do
      org = @role.organizations.create(:title => "org1")
      org.should have(:no).error
    end
    
    it "should fail creating an organization through fulfills" do
      org = @role.organizations.create()
      org.should have(1).error_on(:title)
    end
  end
end
