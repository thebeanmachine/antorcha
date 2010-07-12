require 'spec_helper'

describe "/castables/new.html.erb" do
  include CastablesHelper

  before(:each) do
    assigns[:castable] = stub_model(Castable,
      :new_record? => true,
      :user => 1,
      :role => 1
    )
  end

  it "renders new castable form" do
    render

    response.should have_tag("form[action=?][method=post]", castables_path) do
      with_tag("input#castable_user[name=?]", "castable[user]")
      with_tag("input#castable_role[name=?]", "castable[role]")
    end
  end
end
