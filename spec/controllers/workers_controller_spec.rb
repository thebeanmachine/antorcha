require 'spec_helper'

describe WorkersController do
  
  before(:each) do    
    sign_in_user
  end
  
  describe "GET index" do
    it "should assign @workers with all workers" do
      Worker.stub(:all => [:all, :workers])
      get :index
      assigns[:workers].should == [:all, :workers]
    end
  end
  
  describe "POST create" do
    def stub_create_action
      Worker.stub(:start => nil)
    end
    
    it "should create a new worker" do
      stub_create_action
      Worker.should_receive(:start)
      post :create
    end
    
    it "should redirect to index" do
      stub_create_action
      post :create
      response.should redirect_to(workers_url)
    end
  end
  
  describe "DELETE destroy" do
    def stub_destroy_action
      Worker.stub :all => mock_workers
      mock_worker.stub :to_param => 'aap', :stop => nil
    end
    
    def delete_destroy id = 'aap'
      delete :destroy, :id => id
    end
    
    it "should stop the matching worker" do
      stub_destroy_action
      mock_worker.should_receive :stop
      delete_destroy
    end

    it "should not stop the other workers" do
      stub_destroy_action
      mock_worker.should_not_receive :stop
      delete_destroy 'noot'
    end


    it "should redirect to workers index" do
      stub_destroy_action
      delete_destroy
      response.should redirect_to(workers_url)
    end
  end
  
end
