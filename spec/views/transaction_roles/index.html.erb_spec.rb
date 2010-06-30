require 'spec_helper'

describe "/transaction_roles/index.html.erb" do
  include TransactionRolesHelper

  before(:each) do
    assigns[:transaction_roles] = [
      stub_model(TransactionRole,
        :title => "value for title"
      ),
      stub_model(TransactionRole,
        :title => "value for title"
      )
    ]
  end

  it "renders a list of transaction_roles" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
