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

    it "should not validate presence of name if title is missing" do
      should have(:no).error_on(:name)
    end
  end
  
  describe "name" do
    it "should be unique" do
      Step.create(:title => 'aap')
      step = Step.create(:title => 'aap')
      step.should have(1).error_on(:name)
    end
    
    it "should parameterize title" do
      step = Step.create(:title => 'aap, noot & mies')
      step.name.should == 'aap-noot-mies'
    end
  end
end
