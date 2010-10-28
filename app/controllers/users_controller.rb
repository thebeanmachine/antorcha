class UsersController < ApplicationController
  
  authorize_resource
  
  def index
    @users = User.inactivated.all
    flash[:notice] = "Er zijn momenteel geen geregistreerde gebruikers." if @users.empty?
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attribute(:user_type, "communicator")
      @user.update_attribute(:activated, true) # Bah.... dit had ik anders kunnen doen :)
      flash[:notice] = "Gebruiker is geactiveerd"
      redirect_to root_path
    else
      flash[:error] = "Deze gebruiker is niet geactiveerd"
      redirect_to users_path
    end
  end
end
