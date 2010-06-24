require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :name => "value for name",
      :definition_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
end
