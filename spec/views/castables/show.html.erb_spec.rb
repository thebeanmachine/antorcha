require 'spec_helper'

describe "/castables/show.html.erb" do
  include CastablesHelper
  before(:each) do
    assigns[:castable] = @castable = stub_model(Castable,
      :user => 1,
      :role => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
