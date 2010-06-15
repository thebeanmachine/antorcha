require 'spec_helper'

describe Message do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :body => "value for body",
      :incoming => false,
      :step => mock_model(Step)
    }
  end

  it "should create a new instance given valid attributes" do
    Message.create!(@valid_attributes)
  end
  
  describe "empty message" do
    subject { Message.create }
    
    specify { should have(1).error_on(:title) }
    specify { should have(1).error_on(:step) }
    
  end
  
  
  
end
