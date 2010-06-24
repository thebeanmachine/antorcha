require 'spec_helper'

describe Definition do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Definition.create!(@valid_attributes)
  end
  
  describe "empty definition" do
    subject { Definition.create }
    it "should validate presence of title" do
      should have(1).error_on(:title)
    end

    it "should not validate presence of name if title is missing" do
      should have(:no).error_on(:name)
    end
  end
  
  describe "name" do
    it "should be unique" do
      Definition.create(:title => 'aap')
      definition = Definition.create(:title => 'aap')
      definition.should have(1).error_on(:name)
    end
    
    it "should parameterize title" do
      definition = Definition.create(:title => 'aap, noot & mies')
      definition.name.should == 'aap-noot-mies'
    end
  end
  
end
