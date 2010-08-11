require 'spec_helper'

describe Step do

  it "should be tested against olympus"

  it "should send to a selection of organizations and not to all organizations"

  # before(:each) do
  #   @valid_attributes = {
  #     :title => "value for title"
  #   }
  # end
  # 
  # it "should create a new instance given valid attributes" do
  #   Step.create!(@valid_attributes)
  # end
  # 
  # describe "empty step" do
  #   subject { Step.create }
  #   it "should validate presence of title" do
  #     should have(1).error_on(:title)
  #   end
  # 
  #   it "should not validate presence of name if title is missing" do
  #     should have(:no).error_on(:name)
  #   end
  # end
  # 
  # describe "name" do
  #   it "should be unique" do
  #     Step.create(:title => 'aap')
  #     step = Step.create(:title => 'aap')
  #     step.should have(1).error_on(:name)
  #   end
  #   
  #   it "should parameterize title" do
  #     step = Step.create(:title => 'aap, noot & mies')
  #     step.name.should == 'aap-noot-mies'
  #   end
  # end
  # 
  # describe "fetch destination organizations" do
  #   before(:each) do
  #     Antorcha.definition "noot" do |noot|
  #       noot.role "aap"
  #       noot.step "mies" do |mies|
  #         mies.recipients "aap"
  #       end
  #     end
  #     Antorcha.organization "bean" do |bean|
  #       bean.fulfills "noot" => "aap"
  #     end
  #   end
  # 
  #   subject { Step.find_by_title 'mies' }
  #   
  #   it "should find organization bean" do
  #     @bean = Organization.find_by_title 'bean'
  #     subject.destination_organizations.should == [@bean]
  #   end
  #   
  # end

end
