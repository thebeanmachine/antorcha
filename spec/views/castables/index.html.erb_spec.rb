require 'spec_helper'

describe "/castables/index.html.erb" do
  include CastablesHelper

  before(:each) do
    assigns[:castables] = [
      stub_model(Castable,
        :user => mock_user,
        :role => mock_role
      ),
      stub_model(Castable,
        :user => mock_user,
        :role => mock_role
      )
    ]
    
    mock_user.stub :username => 'Piet Vogelaars'
    mock_role.stub :title => "Whatever"
  end

  it "renders a list of castables" do
    pending
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
