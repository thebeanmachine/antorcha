require 'spec_helper'

describe Jobs::ReceiveMessageJob do
  subject do
    stub_find mock_reception
    Jobs::ReceiveMessageJob.new mock_reception.to_param
  end
  
  
  describe "reception which has already been received." do
    before(:each) do
      mock_reception.stub :just_arrived? => false
    end
    
    it "should just ignore the reception and not process it" do
      mock_reception.should_not_receive(:process)
      subject.perform
    end
  end


  describe "reception of a new message which has just arrived." do
    before(:each) do
      mock_reception.stub :just_arrived? => true
    end
    
    describe "successful processing" do
      it "should process the reception" do
        mock_reception.should_receive(:process).and_return(true)
        subject.perform
      end
    end

    describe "unsuccessful processing" do
      it "should raise an error, because then it will be retried for 3 days." do
        mock_reception.should_receive(:process).and_return(false)
        lambda { subject.perform }.should raise_error(/Message could not be received/)
      end
    end

  end

end
