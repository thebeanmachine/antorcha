require 'spec_helper'

describe "/roles/edit.html.erb" do
  include RolesHelper

  before(:each) do
    assigns[:role] = @role = stub_model(Role,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "renders the edit role form" do
    render

    response.should have_tag("form[action=#{role_path(@role)}][method=post]") do
      with_tag('input#role_title[name=?]', "role[title]")
    end
  end
end
