require 'spec_helper'

describe Worker do
  describe "finds delayed job workers" do
    it "works" do
      debug Worker.all.inspect
    end
  end
  
  describe "can create a new delayed_job" do
    it "start" do
      Worker.start
    end
  end
end
