require 'spec_helper'

describe Identity do
  before(:each) do
    @valid_attributes = {
      :string => ,
      :string => ,
      :organization_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Identity.create!(@valid_attributes)
  end
end
