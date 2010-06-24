require 'spec_helper'

describe "/transactions/edit.html.erb" do
  include TransactionsHelper

  before(:each) do
    assigns[:transaction] = @transaction = stub_model(Transaction,
      :new_record? => false,
      :title => "value for title",
      :name => "value for name",
      :definition => mock_definition
    )
    
    assigns[:definitions] = mock_definitions
    mock_definition.stub :title => 'My Definition'
  end

  it "renders the edit transaction form" do
    render

    response.should have_tag("form[action=#{transaction_path(@transaction)}][method=post]") do
      with_tag('input#transaction_title[name=?]', "transaction[title]")
      with_tag("input[name=?]", "transaction[definition_id]")
    end
  end
end
