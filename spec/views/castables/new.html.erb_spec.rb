require 'spec_helper'

describe "/castables/new.html.erb" do
  include CastablesHelper

  before(:each) do
    
    sign_in_user
    
    assigns[:castable] = stub_model(Castable,
      :new_record? => true,
      :user => mock_user,
      :role => mock_role
    )
  end

  it "renders new castable form" do
    pending
    render

    response.should have_tag("form[action=?][method=post]", castables_path) do
      with_tag("input#castable_user[name=?]", "castable[user]")
      with_tag("input#castable_role[name=?]", "castable[role]")
    end
  end
end
