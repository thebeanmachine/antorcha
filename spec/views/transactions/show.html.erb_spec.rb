require 'spec_helper'

describe "/transactions/show.html.erb" do
  include TransactionsHelper

  before(:each) do
    view_as_user :communicator
    
    assigns[:transaction] = mock_transaction
    
    mock_transaction.stub \
      :title => "value for title",
      :name => "value for name",
      :definition => mock_definition,
      :cancelled? => false,
      :stopped? => false
    
    mock_definition.stub \
      :title => 'My Definition'
  end

  it "renders attributes in <p>" do
    template.stub(:admin_signed_in? => true)
    render
    response.should have_text(/value\ for\ title/)
  end
  
  it "has link to definition" do
    pending "link is removed due to movement to olympus"
    render
    response.should have_tag('a[href=?]', definition_path(mock_definition), 'My Definition')
  end
end
