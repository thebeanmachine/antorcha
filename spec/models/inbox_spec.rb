require 'spec_helper'

describe Inbox do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    Inbox.create!(@valid_attributes)
  end
end
