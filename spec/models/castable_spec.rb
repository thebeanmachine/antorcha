require 'spec_helper'

describe Castable do
  before(:each) do
    @valid_attributes = {
      :user => mock_user,
      :role => mock_role
    }
  end

  it "should create a new instance given valid attributes" do
    Castable.create!(@valid_attributes)
  end
end
