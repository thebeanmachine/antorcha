require 'spec_helper'

describe Task do
  before(:each) do
    @valid_attributes = {
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end
  
  describe "empty task" do
    subject { Task.create }
    it "should validate presence of title" do
      should have(1).error_on(:title)
    end

    it "should not validate presence of name if title is missing" do
      should have(:no).error_on(:name)
    end
  end
  
  describe "name" do
    it "should be unique" do
      Task.create(:title => 'aap')
      task = Task.create(:title => 'aap')
      task.should have(1).error_on(:name)
    end
    
    it "should parameterize title" do
      task = Task.create(:title => 'aap, noot & mies')
      task.name.should == 'aap-noot-mies'
    end
  end
  
end
