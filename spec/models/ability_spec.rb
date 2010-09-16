require 'spec_helper'
require "cancan/matchers"

describe Ability do
  include ActAct
    
  def self.all_roles
    [:communicator, :maintainer, :advisor, :anonymous]
  end

  class Abilities < Array
    def can? *args
      each do |ability|
        return false unless ability.can? *args
      end
    end
  end

  def self.ability_of role, &block
    x = subclass "by #{role}", &block
    local_role = role
    x.subject { u = User.new; u.user_type = local_role.to_s; Ability.new(u) }
  end

  def self.everyone_else_but role, &block
    (all_roles - [role]).each do |role|
      ability_of role, &block
    end
  end

  it "should check if one can cancel a message using the cancellable? attribute"

  def ability_of role, options = {}
    user = User.new
    user.stub :castables => castables_for(options.delete(:as)) if options[:as]
    
    user.user_type = role.to_s;
    Ability.new(user)
  end


  def everyone_else_but role
    Abilities.new(([:communicator, :maintainer, :advisor, :anonymous] - [role]).collect do |role|
      ability_of role
    end)
  end


  describe "identity management by maintainer" do
    subject { ability_of :maintainer }
    
    it 'should be possible to show identity' do
      showing(Identity).should be_possible
    end
  end

  it "is only possible for a communicator to send a message" do
    ability_of(:communicator).should be_able_to(:send, Message)
    everyone_else_but(:communicator).should_not be_able_to(:send, Message)
  end

  describe "initiation and starting of transactions" do
    it "should not be possible for a communicator if it is not casted into a role" do
      ability_of(:communicator).should_not be_able_to(:create, Transaction)
    end
    it "should be possible for a user cast into a role" do
      ability_of(:communicator, :as => :hulpverlener).should be_able_to(:create, Transaction)
    end
  end

  describe "reading the index of transactions" do
    it "should be able for the maintainer" do
      ability_of(:maintainer).should be_able_to(:index, Transaction)
    end
    it "should not be able for anyone but maintainer" do
      everyone_else_but(:maintainer).should_not be_able_to(:index, Transaction)
    end
  end

  describe "cancellation of transactions" do
    ability_of :communicator do
      specify { should be_able_to(:cancel, Transaction)}
    end
  end
  

  describe "the examination of a message" do
    ability_of :communicator do
      it "can only be done by a communicator" do
        should be_able_to(:examine, Message)
      end
    end
    
    everyone_else_but :communicator do |other|
      it "should not be allowed" do
        should_not be_able_to(:examine, Message)
      end
    end
  end
  
  describe "updating of a message" do
    ability_of :communicator do
      it "should not be allowed to update a not updatable message" do
        mock_message.stub :updatable? => false
        should_not be_able_to( :update, mock_message)
      end
      it "should be allowed to update an updatable message" do
         mock_message.stub :updatable? => true
        should be_able_to( :update, mock_message)
      end
    end
  end
  
  describe "starting and stopping a worker" do
    ability_of :maintainer do
      it "can only be managed by a maintainer" do
        should be_able_to(:manage, Worker)
      end
    end

    everyone_else_but :maintainer do |other|
      it "cannot manage a worker" do
        should_not be_able_to(:manage, Worker)
      end
    end
  end
end
