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

  describe "with no attributes at all" do
    subject { User.create }
    specify { should have(4).errors }
    specify { should have(1).error_on(:email)}
    specify { should have(1).error_on(:username)}
    specify { should have(1).error_on(:password)}
    specify { should have(1).error_on(:password_confirmation)}
  end

  describe "uniqueness of e-mail" do
    subject do
      User.create! \
        :username => 'aap', :email => 'aap@example.com',
        :password => 'nootjes', :password_confirmation => 'nootjes'

      User.new :username => 'aap', :email => 'aap@example.com'
    end
    it "should check uniqueness of email" do
      should have(1).error_on(:email)
    end
    it "should check uniqueness of username" do
      should have(1).error_on(:username)
    end
  end

  describe "of type maintainer" do
    subject { User.new.tap {|u| u.user_type = 'maintainer'} }
    specify { subject.should be_maintainer }
    specify { subject.should_not be_communicator }
  end

  describe "of type communicator" do
    subject { User.new.tap {|u| u.user_type = 'communicator'} }
    specify { subject.should be_communicator }
    specify { subject.should_not be_maintainer }
  end

end
