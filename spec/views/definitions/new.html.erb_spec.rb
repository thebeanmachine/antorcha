require 'spec_helper'

describe "/definitions/new.html.erb" do
  include DefinitionsHelper

  before(:each) do
    assigns[:definition] = stub_model(Definition,
      :new_record? => true,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders new definition form" do
    render

    response.should have_tag("form[action=?][method=post]", definitions_path) do
      with_tag("input#definition_title[name=?]", "definition[title]")
    end
  end
end
