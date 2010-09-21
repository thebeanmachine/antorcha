require 'spec_helper'

describe "/processings/index" do
  before(:each) do
    pending
    render 'processings/index'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/processings/index])
  end
end
