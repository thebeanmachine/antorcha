require 'spec_helper'

describe Step do

  subject {
    Step.new :id => 37
  }

  describe "step effects" do
    it "should get the effects from a step from the subcollection effects on olympus" do
      Step.should_receive(:find).with(:all, :from => "/steps/37/effects.xml")
      subject.effects
    end

    it "should return destination organization for 'Melding aan VIS2'" do
      melding = Step.find_by_title! 'Melding aan VIS2'
      melding.effects.collect(&:title).sort.should == [
        "Informatieverzoek (gegevens actueel houden)",
        "Reactie op melding VIS2"
      ]
    end
  end
  
  describe "starting steps" do
    it "should send query to the correct url" do
      Step.should_receive(:find).with(:all, :from => :start)
      Step.to_start_with
    end
    
    it "should return the defined fixtures" do
      Step.to_start_with.collect(&:title).sort.should include("Melding aan VIS2", "Informatieverzoek (gegevens actueel houden)")
    end
  end

  describe "destination organizations" do
    it "should send query to the correct url" do
      Organization.should_receive(:find).with(:all, :from => "/steps/37/destination_organizations.xml")
      subject.destination_organizations
    end
    
    it "should return destination organization for 'Melding aan VIS2'" do
      melding = Step.find_by_title! 'Melding aan VIS2'
      melding.destination_organizations.collect(&:title).should == ['Verzamelpunt VIS2']
    end
  end

end
