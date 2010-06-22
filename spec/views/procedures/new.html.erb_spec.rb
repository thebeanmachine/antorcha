require 'spec_helper'

describe "/procedures/new.html.erb" do
  include ProceduresHelper

  before(:each) do
    assigns[:procedure] = stub_model(Procedure,
      :new_record? => true,
      :title => "value for title",
      :name => "value for name"
    )
  end

  it "renders new procedure form" do
    render

    response.should have_tag("form[action=?][method=post]", procedures_path) do
      with_tag("input#procedure_title[name=?]", "procedure[title]")
    end
  end
end
