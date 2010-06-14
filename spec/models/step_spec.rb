require 'spec_helper'

describe Step do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Step.create!(@valid_attributes)
  end
  
  describe "empty step" do
    subject { Step.create }
    it "should validate presence of title" do
      should have(1).error_on(:title)
    end
  end
end
