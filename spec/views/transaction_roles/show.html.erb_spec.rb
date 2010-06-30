require 'spec_helper'

describe "/transaction_roles/show.html.erb" do
  include TransactionRolesHelper
  before(:each) do
    assigns[:transaction_role] = @transaction_role = stub_model(TransactionRole,
      :title => "value for title"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
  end
end
