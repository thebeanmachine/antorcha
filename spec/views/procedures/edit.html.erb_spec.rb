require 'spec_helper'

describe "/procedures/edit.html.erb" do
  include ProceduresHelper

  before(:each) do
    assigns[:procedure] = @procedure = stub_model(Procedure,
      :new_record? => false,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders the edit procedure form" do
    render

    response.should have_tag("form[action=#{procedure_path(@procedure)}][method=post]") do
      with_tag('input#procedure_title[name=?]', "procedure[title]")
      with_tag('input#procedure_name[name=?]', "procedure[name]")
    end
  end
end
