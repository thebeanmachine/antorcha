require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :definition => mock_definition
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
  
  describe "validations" do
    subject { t = Transaction.new; t.save; t}
    it "should not have a manditory title" do
      should have(:no).error_on(:title)
    end
    specify { should have(1).error_on(:definition) }
  end
  
  describe "unique uri" do
    subject {
      p = Transaction.create!(@valid_attributes)
      p.update_attributes :title => 'bla'
      p
    }
    it "should nag about the uri on the first update" do
      should have(1).error_on(:uri)
    end
  end
end
