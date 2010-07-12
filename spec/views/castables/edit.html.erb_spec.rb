require 'spec_helper'

describe "/castables/edit.html.erb" do
  include CastablesHelper

  before(:each) do
    assigns[:castable] = @castable = stub_model(Castable,
      :new_record? => false,
      :user => 1,
      :role => 1
    )
  end

  it "renders the edit castable form" do
    render

    response.should have_tag("form[action=#{castable_path(@castable)}][method=post]") do
      with_tag('input#castable_user[name=?]', "castable[user]")
      with_tag('input#castable_role[name=?]', "castable[role]")
    end
  end
end
