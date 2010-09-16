require 'spec_helper'

describe Reception do
  before(:each) do
    @valid_attributes = {
      :certificate => "value for certificate",
      :body => "value for body",
      :message_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Reception.create!(@valid_attributes)
  end
end
