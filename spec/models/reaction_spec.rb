require 'spec_helper'

describe Reaction do
  before(:each) do
    @valid_attributes = {
      :cause_id => 1,
      :effect_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Reaction.create!(@valid_attributes)
  end
end
