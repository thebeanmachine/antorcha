require 'spec_helper'

describe "/identities/edit.html.erb" do
  include IdentitiesHelper

  before(:each) do
    assigns[:identity] = @identity = stub_model(Identity,
      :new_record? => false,
      :string => ,
      :string => ,
      :organization_id => 1
    )
  end

  it "renders the edit identity form" do
    render

    response.should have_tag("form[action=#{identity_path(@identity)}][method=post]") do
      with_tag('input#identity_string[name=?]', "identity[string]")
      with_tag('input#identity_string[name=?]', "identity[string]")
      with_tag('input#identity_organization_id[name=?]', "identity[organization_id]")
    end
  end
end
