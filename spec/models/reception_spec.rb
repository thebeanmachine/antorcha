require 'spec_helper'

describe Reception do

  it "should have a robust means of determining if a message has been received already, for example a unique clause on organization and delivery."

  describe "Creating a reception triggers a message receive job" do
    subject do
      reception = Reception.new \
        :delivery_id => mock_delivery.to_param,
        :organization => mock_organization
      reception.content = 'content'
      reception.certificate = 'cert'
      reception
    end
    
    it "should enqueue the job" do
      receive_message_job = mock(Jobs::ReceiveMessageJob)
      Jobs::ReceiveMessageJob.stub :new => receive_message_job

      Delayed::Job.should_receive(:enqueue).with(receive_message_job)
      subject.save!
    end
  end

  describe "Confirming a reception triggers a message receive job" do
    subject do
      reception = Reception.new \
        :delivery_id => mock_delivery.to_param,
        :organization => mock_organization
      reception.content = 'content'
      reception.certificate = 'cert'
      reception.message = mock_message
      reception
    end
    
    it "should enqueue the job" do
      confirm_reception_job = mock(Jobs::ConfirmReceptionJob)
      Jobs::ConfirmReceptionJob.stub :new => confirm_reception_job

      Delayed::Job.should_receive(:enqueue).with(confirm_reception_job)
      subject.save!
    end
  end

  describe "Creating a message from the reception" do
    subject do
      stub_new mock_message
      mock_message.stub :from_hash => mock_message, :save => true
      mock_message.stub :organization=

      Reception.new.tap do |r|
        r.attributes = {
          :delivery_id => mock_delivery.to_param,
          :organization => mock_organization
        }
        r.content = 'content'
        r.certificate = 'cert'
      end
    end
    
    it "should be just arrived? because this is used to determine if it has to be processed" do
      subject.should be_just_arrived
    end

    it "should assign organization to message, because it is needed to show the sender and not part of the hash" do
      mock_message.should_receive(:organization=).with(mock_organization)
      subject.process
    end

    it "should construct the message from the content hash, because this is the main part of the received message" do
      mock_message.should_receive(:from_hash).with('content')
      subject.process
    end

    describe "successful save" do
      it "message is saved" do
        mock_message.should_receive(:save).and_return true
        subject.process
      end

      it "message and this reception is saved" do
        subject.process
        subject.message.should == mock_message
        subject.changes.should be_empty
      end
    end

    describe "unsuccessful save" do
      it "raises an error" do
        mock_message.should_receive(:save).and_return false
        mock_message.errors.stub :full_messages => 'fouten'
        lambda { subject.process }.should raise_error
      end
    end

  end

  describe "Contract for the resource mixin" do
    subject { Reception.new :organization => mock_organization }

    it "should respond to https? and url" do
      subject.should respond_to(:https?)
      subject.should respond_to(:url)
    end
    
    it "should delegate whether the resources uses https to organization" do
      mock_organization.should_receive :https?
      subject.https?
    end

    it "should delegate where the resource url to organization" do
      mock_organization.should_receive(:delivery_confirmation_url).with(subject.id).and_return 'wurl'
      subject.url.should == 'wurl'
    end
  end
    
end
