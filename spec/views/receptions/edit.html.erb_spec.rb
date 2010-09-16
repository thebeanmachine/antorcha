require 'spec_helper'

describe "/receptions/edit.html.erb" do
  include ReceptionsHelper

  before(:each) do
    assigns[:reception] = @reception = stub_model(Reception,
      :new_record? => false,
      :certificate => "value for certificate",
      :body => "value for body",
      :message_id => 1
    )
  end

  it "renders the edit reception form" do
    render

    response.should have_tag("form[action=#{reception_path(@reception)}][method=post]") do
      with_tag('textarea#reception_certificate[name=?]', "reception[certificate]")
      with_tag('textarea#reception_body[name=?]', "reception[body]")
      with_tag('input#reception_message_id[name=?]', "reception[message_id]")
    end
  end
end
