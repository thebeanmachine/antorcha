require 'spec_helper'

describe "/notifiers/new.html.erb" do
  include NotifiersHelper

  before(:each) do
    assigns[:notifier] = stub_model(Notifier,
      :new_record? => true,
      :url => "value for url"
    )
  end

  it "renders new notifier form" do
    render

    response.should have_tag("form[action=?][method=post]", notifiers_path) do
      with_tag("input#notifier_url[name=?]", "notifier[url]")
    end
  end
end
