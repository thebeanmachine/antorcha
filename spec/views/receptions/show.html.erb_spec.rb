require 'spec_helper'

describe "/receptions/show.html.erb" do
  include ReceptionsHelper
  before(:each) do
    assigns[:reception] = @reception = stub_model(Reception,
      :certificate => "value for certificate",
      :body => "value for body",
      :message_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ certificate/)
    response.should_not have_text(/value\ for\ body/)
    response.should have_text(/1/)
  end
end
