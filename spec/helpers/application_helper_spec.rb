require 'spec_helper'

describe ApplicationHelper do
  
  subject {
    class Subject
      include ApplicationHelper
    end.new
  }
  
  describe "crumble" do
    it "should turn classes in to pluralized symbols" do
      subject.crumble(Role).should == [[Role]]
    end
    it "should turn model instances into two routes" do
      subject.crumble(mock_role).should == [[Role],[mock_role]]
    end
    it "should turn multiple models into a chain of routes" do
      subject.crumble(mock_definition, mock_role).should == [
        [Definition],
        [mock_definition],
        [mock_definition, Role],
        [mock_definition, mock_role]
      ]
    end
    it "should be able to crumble shallow routes" do
      subject.shallow_crumble([[mock_definition], [mock_role]]).should == [
        [Definition],
        [mock_definition],
        [mock_definition, Role],
        [mock_role]
      ]
    end
  end

  describe "arrayize" do
    it "should create an array of non arrays" do
      subject.arrayize(:dit, :en, :dat).should == [[:dit,:en,:dat]]
      subject.arrayize(:dit, :en, [:dat]).should == [[:dit,:en],[:dat]]
      subject.arrayize([:dit, :en], :dat).should == [[:dit,:en],[:dat]]
    end
  end
  
end
