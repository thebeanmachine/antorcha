require 'spec_helper'

describe "/receptions/index.html.erb" do
  include ReceptionsHelper

  before(:each) do
    assigns[:receptions] = [
      stub_model(Reception,
        :certificate => "value for certificate",
        :body => "value for body",
        :message_id => 1
      ),
      stub_model(Reception,
        :certificate => "value for certificate",
        :body => "value for body",
        :message_id => 1
      )
    ]
  end

  it "renders a list of receptions" do
    render
    response.should have_tag("tr>td", "value for certificate".to_s, 2)
    response.should have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
