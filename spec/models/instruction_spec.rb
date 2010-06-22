require 'spec_helper'

describe Instruction do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Instruction.create!(@valid_attributes)
  end
  
  describe "empty instruction" do
    subject { Instruction.create }
    it "should validate presence of title" do
      should have(1).error_on(:title)
    end

    it "should not validate presence of name if title is missing" do
      should have(:no).error_on(:name)
    end
  end
  
  describe "name" do
    it "should be unique" do
      Instruction.create(:title => 'aap')
      instruction = Instruction.create(:title => 'aap')
      instruction.should have(1).error_on(:name)
    end
    
    it "should parameterize title" do
      instruction = Instruction.create(:title => 'aap, noot & mies')
      instruction.name.should == 'aap-noot-mies'
    end
  end
end
