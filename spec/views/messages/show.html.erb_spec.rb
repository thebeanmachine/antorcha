require 'spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:message] = mock_message
    
    mock_message.stub \
      :title => "value for title",
      :body => "value for body",
      :include => true,
      :step => mock_step,
      :transaction => mock_transaction,
      :delivered? => false,
      :sent? => true,
      :request => mock_message(:request),
      :sent_at => Time.now,
      :created_at => Time.now,
      :effect_steps => mock_steps
    
    mock_message(:request).stub \
      :title => 'requested message title'

    mock_steps.stub :count => mock_steps.size
  
    mock_step.stub( :title => 'hallo wereld', :definition => mock_definition )
    mock_definition.stub( :title => 'definition title' )
    mock_transaction.stub( :title => 'transaction title' )
  end

  shared_examples_for "message view" do
    it "has a title" do
      render
      response.should have_tag('h1', /value\ for\ title/)
    end
    
    it "renders definition title in <p>" do
      act_as :advisor
      render
      response.should have_tag('p', /definition title/)
    end

    it "renders body" do
      render
      response.should have_text(/value\ for\ body/)
    end
  end

  describe "draft/outgoing message" do
    it_should_behave_like "message view"

    before(:each) do
      mock_message.stub :incoming? => false, :outgoing? => true
    end

    it "renders link to delivery if not sent" do
      act_as :communicator
      mock_message.stub(:sent? => false)
      render
      response.should have_tag('form[action=?] input[type=submit][value=?]', message_deliveries_path(mock_message), 'Verstuur Bericht') 
    end
  end

  describe "received/incoming message" do
    it_should_behave_like "message view"

    before(:each) do
      mock_message.stub :incoming? => true, :outgoing? => false
    end



    it "should not render send link" do
      render
      response.should_not have_text(/Verstuur Bericht/)
    end
    
    it "should not render edit link" do
      render
      response.should_not have_text(/Bewerk Bericht/)
    end
  end
end
