require 'spec_helper'

describe MessageRepliesController do


  describe "GET new" do

    def stub_new_action
      stub_find(mock_message(:origin))
      stub_new(mock_message(:reply))
      mock_message(:origin).stub :definition => mock_definition
      mock_definition.stub :steps => mock_steps
    end

    it "should assign all steps from the definition of the message transaction to @steps" do
      stub_new_action
      get :new, :message_id => mock_message(:origin).to_param
      assigns[:steps].should == mock_steps
    end

    it "should assign new reply message to @message" do
      stub_new_action
      get :new, :message_id => mock_message(:origin).to_param
      assigns[:message].should == mock_message(:reply)
    end

  end


end
