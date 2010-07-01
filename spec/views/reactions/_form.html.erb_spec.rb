require 'spec_helper'

describe "/reactions/_form.html.erb" do
  include ReactionsHelper

  before(:each) do
    assigns[:reaction] = mock_reaction
    assigns[:causes] = mock_steps
    assigns[:effects] = mock_steps
    
    mock_step.stub :title => 'title value'
    
    mock_reaction.as_null_object.stub \
      :errors => stub("errors").as_null_object
  end

  it "renders new reaction form" do
    mock_reaction.as_new_record
    render

    response.should have_tag("form[action=?][method=post]", reactions_path) do
      with_tag("input[name=?]", "reaction[cause_id]")
      with_tag("input[name=?]", "reaction[effect_id]")
    end
  end

  it "renders edit reaction form" do
    render

    response.should have_tag("form[action=?][method=post]", reaction_path(mock_reaction)) do
      with_tag("input[name=?]", "reaction[cause_id]")
      with_tag("input[name=?]", "reaction[effect_id]")
    end
  end
end
