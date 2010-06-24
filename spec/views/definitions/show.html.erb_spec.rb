require 'spec_helper'

describe "/definitions/show.html.erb" do
  include DefinitionsHelper
  before(:each) do
    assigns[:definition] = @definition = stub_model(Definition,
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
