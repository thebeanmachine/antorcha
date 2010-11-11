require 'spec_helper'

describe "/notifiers/edit.html.erb" do
  include NotifiersHelper

  before(:each) do
    assigns[:notifier] = @notifier = stub_model(Notifier,
      :new_record? => false,
      :url => "value for url"
    )
  end

  it "renders the edit notifier form" do
    render

    response.should have_tag("form[action=#{notifier_path(@notifier)}][method=post]") do
      with_tag('input#notifier_url[name=?]', "notifier[url]")
    end
  end
end
