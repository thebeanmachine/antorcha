require 'spec_helper'

describe Permission do
  before(:each) do
    @valid_attributes = {:role => Factory(:role), :step => Factory(:step)}
  end

  it "should create a new instance given valid attributes" do
    Permission.create!(@valid_attributes)
  end
end
