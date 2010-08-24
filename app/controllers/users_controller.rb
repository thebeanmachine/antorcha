class UsersController < ApplicationController
  
  authorize_resource
  
  def index
    @users = User.inactivated.all
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attribute(:user_type, "communicator")
      @user.update_attribute(:activated, true) # Bah.... dit had ik anders kunnen doen :)
      flash[:notice] = "User is activated"
      redirect_to root_path
    else
      flash[:error] = "User is not activated"
      redirect_to users_path
    end
  end
end
