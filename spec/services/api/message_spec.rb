require 'spec_helper'

describe Api::Message do
  before(:each) do
    mock_transaction.as_null_object
    mock_transaction.stub :cancelled? => false, :expired? => false
  end
  
  it "should convert from a Message" do
    Api::Message.new Message.create(:transaction => mock_transaction)
  end

  it "should convert from a Message and set the title" do
    msg = Api::Message.new Message.create(:title => 'aap',:transaction => mock_transaction)
    msg.title.should == 'aap'
  end

  
end
