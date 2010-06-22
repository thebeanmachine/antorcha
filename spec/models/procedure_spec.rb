require 'spec_helper'

describe Procedure do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Procedure.create!(@valid_attributes)
  end
  
  describe "empty procedure" do
    subject { Procedure.create }
    it "should validate presence of title" do
      should have(1).error_on(:title)
    end

    it "should not validate presence of name if title is missing" do
      should have(:no).error_on(:name)
    end
  end
  
  describe "name" do
    it "should be unique" do
      Procedure.create(:title => 'aap')
      procedure = Procedure.create(:title => 'aap')
      procedure.should have(1).error_on(:name)
    end
    
    it "should parameterize title" do
      procedure = Procedure.create(:title => 'aap, noot & mies')
      procedure.name.should == 'aap-noot-mies'
    end
  end
  
end
