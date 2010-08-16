require 'spec_helper'

describe User do
  describe "with minimal attributes" do
    subject do
      User.create \
        :username => 'aap', :email => 'aap@example.com',
        :password => 'nootjes', :password_confirmation => 'nootjes'
    end
    
    specify { should have(:no).errors }
    specify { should be_registered }
  end

  describe "of type maintainer" do
    subject { user = User.new; user.user_type = 'maintainer'; user }
    specify { subject.should be_maintainer }
    specify { subject.should_not be_communicator }
  end

  describe "of type communicator" do
    subject { user = User.new; user.user_type = 'communicator'; user }
    specify { subject.should be_communicator }
    specify { subject.should_not be_maintainer }
  end

end
