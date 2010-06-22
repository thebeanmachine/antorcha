require 'spec_helper'

describe "/procedures/index.html.erb" do
  include ProceduresHelper

  before(:each) do
    assigns[:procedures] = [
      stub_model(Procedure,
        :title => "value for title",
        :name => "value for name"
      ),
      stub_model(Procedure,
        :title => "value for title",
        :name => "value for name"
      )
    ]
  end

  it "renders a list of procedures" do
    render
    response.should have_tag("a", "value for title".to_s, 2)
  end
end
