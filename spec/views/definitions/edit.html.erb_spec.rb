require 'spec_helper'

describe "/definitions/edit.html.erb" do
  include DefinitionsHelper

  before(:each) do
    assigns[:definition] = @definition = stub_model(Definition,
      :new_record? => false,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders the edit definition form" do
    render

    response.should have_tag("form[action=#{definition_path(@definition)}][method=post]") do
      with_tag('input#definition_title[name=?]', "definition[title]")
    end
  end
end
