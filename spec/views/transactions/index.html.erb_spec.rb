require 'spec_helper'

describe "/transactions/index.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transactions] = [
      stub_model(Transaction,
        :title => "value for title",
        :name => "value for name",
        :definition => mock_definition
      ),
      stub_model(Transaction,
        :title => "value for title",
        :name => "value for name",
        :definition => mock_definition
      )
    ]
    
    mock_definition.stub \
      :title => 'My Definition'
  end

  it "renders a list of transactions" do
    render
    response.should have_tag("ul li a", "value for title".to_s, 2)
  end
end
