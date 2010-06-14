require 'spec_helper'

describe "/steps/edit.html.erb" do
  include StepsHelper

  before(:each) do
    assigns[:step] = @step = stub_model(Step,
      :new_record? => false,
      :title => "value for title"
    )
  end

  it "renders the edit step form" do
    render

    response.should have_tag("form[action=#{step_path(@step)}][method=post]") do
      with_tag('input#step_title[name=?]', "step[title]")
    end
  end
end
