require 'spec_helper'

describe "/castables/edit.html.erb" do
  include CastablesHelper

  before(:each) do
    sign_in_user
    
    assigns[:castable] = @castable = stub_model(Castable,
      :new_record? => false,
      :user => mock_user,
      :role => mock_role
    )
  end

  it "should display the div" do
    render :partial => "/castables/form", :locals => { :btn_name => "Update" }  
    response.should have_tag('div#div-id')  
  end


  # it "renders the edit castable form" do
  #   # pending
  #   render
  # 
  #   # response.should have_tag("form[action=#{castable_path(@castable)}][method=post]") do
  #   #   with_tag('input#castable_user[name=?]', "castable[user]")
  #   #   with_tag('input#castable_role[name=?]', "castable[role]")
  #   # end
  # end
end
