require 'spec_helper'

describe Api::ConvertableStruct do
  
  class Smurf < Api::ConvertableStruct
    member :naam, :string
  end
  
  it "should be able to assign a hash" do
    smurf = Smurf.new
    smurf.attributes = {:naam => 'brilsmurf'}
    smurf.naam.should == 'brilsmurf'
  end
  
  it "should be able to give a hash of attributes" do
    Smurf.new( :naam => 'brilsmurf' ).attributes.should == { :naam => 'brilsmurf' }
  end
end
