require 'spec_helper'

describe "/transaction_roles/edit.html.erb" do
  include TransactionRolesHelper

  before(:each) do
    assigns[:transaction_role] = @transaction_role = stub_model(TransactionRole,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "renders the edit transaction_role form" do
    render

    response.should have_tag("form[action=#{transaction_role_path(@transaction_role)}][method=post]") do
      with_tag('input#transaction_role_title[name=?]', "transaction_role[title]")
    end
  end
end
