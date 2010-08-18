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
  
  describe "with organizations scope" do
    it "should get the transactions communicating with an organization" do
      mock_step.stub :title => 'aap'
      @transaction = Transaction.create!(@valid_attributes)
      @message = @transaction.messages.create!( :step => mock_step )
    
      @message.deliveries.create! :organization_id => 2

      Transaction.with_organizations([2]).should == [@transaction]
      Transaction.with_organizations([3]).should == []
    end
  end
end
