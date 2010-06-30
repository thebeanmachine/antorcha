require 'spec_helper'

describe Organization do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    Organization.create!(@valid_attributes)
  end
end
