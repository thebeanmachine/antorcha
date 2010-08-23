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
    subject { Transaction.create }
    it "should not have a manditory title" do
      should have(:no).error_on(:title)
    end
    specify { should have(1).error_on(:definition) }
  end
  
  describe "unique uri" do
    subject {
      Transaction.create!(@valid_attributes).tap do |t|
        t.update_attributes :title => 'bla'
      end
    }
    it "should nag about the uri on the first update" do
      should have(1).error_on(:uri)
    end
  end
  
  describe "cancel and cascade cancellations" do
    subject do
      Transaction.create(@valid_attributes)
    end
    
    it "should return true" do
      subject.cancel_and_cascade_cancellations.should be_true
    end
    
    it "holds return false if already cancelled" do
      subject.cancelled!
      subject.cancel_and_cascade_cancellations.should be_false
    end

    it "should cancel the transaction" do
      subject.cancel_and_cascade_cancellations
      should be_cancelled
    end
  end
  
end
