require 'spec_helper'

describe "/transactions/new.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transaction] = stub_model(Transaction,
      :new_record? => true,
      :title => "value for title",
      :name => "value for name",
      :definition => nil
    )
    
    assigns[:definitions] = mock_definitions
    mock_definition.stub :title => 'My Definition'
  end

  it "renders new transaction form" do
    render
    
    response.should have_tag("form[action=?][method=post]", transactions_path) do
      with_tag("input#transaction_title[name=?]", "transaction[title]")
      with_tag("input[name=?]", "transaction[definition_id]")
    end
  end
end
