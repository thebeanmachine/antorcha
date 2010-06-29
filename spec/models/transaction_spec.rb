require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :name => "value for name",
      :definition => mock_definition
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
  
  describe "validations" do
    subject { t = Transaction.new; t.save; t}
    specify { should have(1).error_on(:title) }
    specify { should have(1).error_on(:definition) }
  end
end
