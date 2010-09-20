require 'spec_helper'

describe "/messages/show.html.erb" do
  include AntorchaHelper

  before(:each) do
    view_as_user :communicator
        
    assigns[:message] = mock_message
    
    mock_message.stub \
      :title => "value for title",
      :body => "value for body",
      :include => true,
      :step => mock_step,
      :transaction => mock_transaction,
      :delivered? => false,
      :sent? => true,
      :cancelled? => false,
      :cancellable? => true,
      :request => mock_message(:request),
      :sent_at => Time.now,
      :created_at => Time.now,
      :replyable? => true,
      :updatable? => true,
      :expired? => false
    
    mock_message(:request).stub \
      :title => 'requested message title'

    mock_step.stub( :title => 'hallo wereld', :definition => mock_definition )
    mock_definition.stub( :title => 'definition title' )
    mock_transaction.stub( :title => 'transaction title' )

    # niet echt te verklaren waarom dit zo werkt.
    @controller.stub :message_status => 'status of message'
    template.stub :message_status => 'status of message2'
  end

  shared_examples_for "message view" do
    it "has a title" do
      render
      response.should have_tag('h1', /value\ for\ title/)
    end
    
    it "renders definition title in <p>" do
      render
      response.should have_tag('p', /definition title/)
    end

    it "renders body" do
      render
      response.should have_text(/value\ for\ body/)
    end
    
    it "renders status message helper in p" do
      render
      response.should have_tag('p',/status of message/)
    end
  end

  describe "draft/outgoing message" do
    it_should_behave_like "message view"

    before(:each) do
      mock_message.stub :incoming? => false, :outgoing? => true
    end

    it "renders link to delivery if not sent" do
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
  
  describe "cancelled message" do
    it_should_behave_like "message view"
    before(:each) do
      mock_message.stub :incoming? => true, :outgoing? => false, :cancelled? => :cancelled
    end
    
    it "should show the message as cancelled" do
      render
      response.should have_tag("div.cancelled")
    end
  end
end
