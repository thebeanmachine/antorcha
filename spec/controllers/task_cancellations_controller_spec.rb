require 'spec_helper'

describe TaskCancellationsController do
  describe "POST create" do
    
    def stub_create_action
      stub_find(mock_task)
      mock_task.stub(:cancelled! => nil)
    end
    
    def post_create
      post :create, :task_id => mock_task.to_param
    end
    
    it "should redirect to the task" do
      stub_create_action
      post_create
      response.should redirect_to(task_path(mock_task))
    end

    it "should flag task as cancelled" do
      stub_create_action
      mock_task.should_receive(:cancelled!)
      post_create
    end

    it "should flash cancellation" do
      stub_create_action
      post_create
      flash[:notice].should =~ /Task was successfully cancelled/
    end
    
    it "should create a cancellation job to cascade cancellation over the network"
  end
end
