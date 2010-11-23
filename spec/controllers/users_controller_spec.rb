require 'spec_helper'

describe UsersController do

  include Devise::TestHelpers

  before(:each) do
    turn_of_devise_and_cancan_because_this_is_specced_in_the_ability_spec
  end
  
  specify { should have_devise_before_filter }

  context "with PUT update" do
    
    context "and a registerd user but not yet a comunicator or a maintainer role" do
           
      it "should flash notice 'Gebruiker is geactiveerd'" do
        mock_user(:inactive).stub :user_type => "registered", :activated => false
        mock_user(:inactive).stub :update_attribute => "communicator"          
        User.should_receive(:find).with("34").and_return(mock_user(:inactive))         
        put :update, :id => "34"      
        flash[:notice].should == "Gebruiker is geactiveerd"        
        response.should redirect_to(users_path)
      end
      
      it "should flash error 'WHOEPS!'" do
        mock_user(:inactive).stub :user_type => "registered", :activated => false
        mock_user(:inactive).stub :update_attribute
        mock_user(:inactive).errors.stub :full_messages => %w(WHOEPS!)          
        User.should_receive(:find).with("34").and_return(mock_user(:inactive))         
        put :update, :id => "34"              
        flash[:error].should == mock_user(:inactive).errors.full_messages        
        response.should redirect_to(users_path)
      end
      
    end
    
    context "and already a communicator or a maintainer role" do
      it "should cast new roles the specific user" do
        mock_user(:active).stub :user_type => "communicator", :activated => true, :castables => mock_castables
        mock_user(:active).stub(:cast)
        mock_castables.stub :destroy_all
        
        User.should_receive(:find).with("34").and_return(mock_user(:active))
        put :update, :id => "34", :roles => [1,2,3]
        
        flash[:notice].should == "Rollen zijn gewijzigd"
        response.should redirect_to users_path
      end
    end
  end

end
