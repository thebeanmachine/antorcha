require 'spec_helper'

describe "/procedures/show.html.erb" do
  include ProceduresHelper
  before(:each) do
    assigns[:procedure] = @procedure = stub_model(Procedure,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ name/)
  end
end
