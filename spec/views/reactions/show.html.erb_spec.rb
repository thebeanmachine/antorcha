require 'spec_helper'

describe "/reactions/show.html.erb" do
  include ReactionsHelper
  before(:each) do
    assigns[:reaction] = @reaction = stub_model(Reaction,
      :cause_id => 1,
      :effect_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
