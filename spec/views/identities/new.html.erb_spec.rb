require 'spec_helper'

describe "/identities/new.html.erb" do
  include IdentitiesHelper

  before(:each) do
    assigns[:identity] = stub_model(Identity,
      :new_record? => true,
      :passphrase => '',
      :private_key => '',
      :organization_id => 1
    )
  end

  it "renders new identity form" do
    render

    response.should have_tag("form[action=?][method=post]", identity_path) do
      with_tag("textarea#identity_private_key[name=?]", "identity[private_key]")
      with_tag("input#identity_passphrase[name=?]", "identity[passphrase]")
    end
  end
end
