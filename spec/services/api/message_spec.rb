require 'spec_helper'

describe Api::Message do
  it "should convert from a Message" do
    Api::Message.new Message.create
  end

  it "should convert from a Message and set the title" do
    msg = Api::Message.new Message.create(:title => 'aap')
    msg.title.should == 'aap'
  end

  
end
