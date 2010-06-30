require 'spec_helper'

describe "/reactions/index.html.erb" do
  include ReactionsHelper

  before(:each) do
    assigns[:reactions] = mock_reactions
    
    mock_reaction.stub \
      :cause => mock_step,
      :effect => mock_step
      
    mock_step.stub :title => 'step title'
    
    act_as :maintainer
  end

  it "renders a list of reactions" do
    render
    #debunk response.body
    response.should have_tag("li a[href=?]", reaction_path(mock_reaction), 2)
  end
end
