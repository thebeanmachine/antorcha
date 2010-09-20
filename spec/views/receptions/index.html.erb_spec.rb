require 'spec_helper'

describe "/receptions/index.html.erb" do
  include ReceptionsHelper

  before(:each) do
    assigns[:receptions] = [
      stub_model(Reception,
        :certificate => "value for certificate",
        :content => "value for body",
        :message => mock_message
      ),
      stub_model(Reception,
        :certificate => "value for certificate",
        :content => "value for body",
        :message => mock_message
      )
    ]
  end

  it "renders a list of receptions" do
    render
    response.should have_tag("tr>td", "value for certificate".to_s, 2)
    response.should_not have_tag("tr>td", "value for body".to_s, 2)
    response.should have_tag("tr>td>a[href=?]", message_path(mock_message.to_param), 2)
  end
end
