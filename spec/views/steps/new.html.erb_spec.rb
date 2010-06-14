require 'spec_helper'

describe "/steps/new.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:step] = stub_model(Step,
      :new_record? => true,
      :title => "value for title"
    )
  end

  it "renders new step form" do
    render

    response.should have_tag("form[action=?][method=post]", steps_path) do
      with_tag("input#step_title[name=?]", "step[title]")
    end
  end
end
