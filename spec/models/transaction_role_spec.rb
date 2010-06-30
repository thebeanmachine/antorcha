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
end
