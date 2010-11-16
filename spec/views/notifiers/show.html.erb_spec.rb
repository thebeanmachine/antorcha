require 'spec_helper'

describe "/notifiers/show.html.erb" do
  include NotifiersHelper
  before(:each) do
    assigns[:notifier] = @notifier = stub_model(Notifier,
      :url => "value for url"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ url/)
  end
end
