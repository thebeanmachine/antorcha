require 'spec_helper'

describe "/notifiers/index.html.erb" do
  include NotifiersHelper

  before(:each) do
    assigns[:notifiers] = [
      stub_model(Notifier,
        :url => "value for url"
      ),
      stub_model(Notifier,
        :url => "value for url"
      )
    ]
  end

  it "renders a list of notifiers" do
    render
    response.should have_tag("ul li", "value for url".to_s, 2)
  end
end
