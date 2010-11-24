require 'spec_helper'

describe Transaction do
  before(:each) do
    
    mock_definition.stub(:expiration_days => 2)
    
    @valid_attributes = {
      :title => "value for title",
      :definition => mock_definition,
      :initialized_at => DateTime.now,
      #:expired_at => (DateTime.now + 2.days)
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
  
  describe "the expiration date" do
    subject { Transaction.create! @valid_attributes }
    describe "calculated from 2 expiration days" do
      it "have expired_at" do
        subject.expired_at.should_not be_nil
      end

      it "should be two days later" do
        subject.expired_at.should == subject.initialized_at + 2.days
      end
      it "should not be expired" do
        should_not be_expired
      end
    end

    describe "calculation with no expiration days" do
      before(:each) do
        mock_definition.stub :expiration_days => nil
      end
      it "should be left blank if there are no expiration days" do
        subject.expired_at.should be_nil
      end
      it "should never be expired" do
        should_not be_expired
      end
    end
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

  describe "with organizations scope" do
    it "should get the transactions communicating with an organization" do
      mock_step.stub :title => 'aap'
      @transaction = Transaction.create!(@valid_attributes)
      mock_user.stub :username => 'piet'
      @message = @transaction.messages.create!( :step => mock_step, :user => mock_user, :incoming => true, :organization => mock_organization )
    
      @message.deliveries.create! :organization_id => 2

      Transaction.organization_ids([2]).should == [@transaction]
      Transaction.organization_ids([3]).should == []
    end
  end

end
