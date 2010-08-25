require 'spec_helper'

describe "/castables/edit.html.erb" do
  include CastablesHelper

  before(:each) do
    view_as_user :communicator
    
    assigns[:castable] = @castable = stub_model(Castable,
      :new_record? => false,
      :user => mock_user,
      :role => mock_role
    )
    assigns[:roles] = [stub_model(Role, :title => "test")]
    assigns[:users] = [stub_model(User, :username => "test")]
  end

  it "renders edit castable form" do
    render

    response.should have_tag("form[action=#{castable_path(@castable)}][method=post]") do
      with_tag("select#castable_user_id[name=?]", "castable[user_id]")
      with_tag("select#castable_role_id[name=?]", "castable[role_id]")
    end
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
