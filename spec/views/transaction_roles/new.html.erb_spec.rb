require 'spec_helper'

describe "/transaction_roles/new.html.erb" do
  include TransactionRolesHelper

  before(:each) do
    assigns[:transaction_role] = stub_model(TransactionRole,
      :new_record? => true,
      :title => "value for title"
    )
  end

  it "renders new transaction_role form" do
    render

    response.should have_tag("form[action=?][method=post]", transaction_roles_path) do
      with_tag("input#transaction_role_title[name=?]", "transaction_role[title]")
    end
  end
end
