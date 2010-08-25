require 'spec_helper'

describe "/messages/index.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:messages] = [
      mock_message(:shown),
      mock_message(:new),
      mock_message(:cancelled)
    ]

    mock_message(:shown).stub \
      :title => "value for title",
      :body => "value for body",
      :shown? => :shown,
      :cancelled? => false,
      :sent? => false,
      :step => mock_step,
      :incoming? => false

    mock_message(:cancelled).stub \
      :title => "value for title",
      :body => "value for body",
      :shown? => false,
      :cancelled? => :cancelled,
      :sent? => false,
      :step => mock_step,
      :incoming? => false
      

    mock_message(:new).stub \
      :title => "value for title",
      :body => "value for body",
      :shown? => false,
      :cancelled? => false,
      :sent? => false,
      :step => mock_step,
      :incoming? => false
    
    mock_step.stub :title => 'step title', :definition => mock_definition
    mock_definition.stub :title => 'definition title'
    
    
    assigns[:steps_starting_steps] = []
  end
  
  shared_examples_for "message index" do
    it "renders titles of messages" do
      render
      response.should have_tag("tr.message>td", /value for title/, 3)
    end

    it "links to message show" do
      render
      response.should have_tag("a[href=?]", message_path(mock_message(:shown)), 1)
    end

    it "renders a shown message" do
      render
      response.should have_tag("tr.message.shown", 1)
    end

    it "renders a cancelled message" do
      render
      response.should have_tag("tr.message.cancelled", 1)
    end
  end
  

  describe "as maintainer" do
    before(:each) do
      view_as_user :maintainer
    end

    it_should_behave_like "message index"

    it "doesn't render titles of messages" do
      render
      response.should_not have_tag("tr.message>td", /step title/, 3)
    end
  end

  describe "as communicator" do
    before(:each) do
      view_as_user :communicator
    end

    it_should_behave_like "message index"
    
    it "renders titles of messages" do
      render
      response.should have_tag("tr.message>td", /value for title/, 3)
    end

  end

end
