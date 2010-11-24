class UsersController < ApplicationController
  
  authorize_resource
  
  def index
    @users = User.all
    @roles = Role.all
    flash[:notice] = "Er zijn momenteel geen gebruikers." if @users.empty?
  end
  
  def update
  
    @user = User.find params[:id]
    
    if @user.user_type == "registered"      
      if @user.update_attribute(:user_type, "communicator") &&  @user.update_attribute(:activated, true)
        flash[:notice] = "Gebruiker is geactiveerd"
      else
        flash[:error] = @user.errors.full_messages
      end
    elsif @user.user_type == "communicator" || @user.user_type == "maintainer"
      @user.castables.destroy_all
      @user.cast(params[:roles]) if params[:roles]
      flash[:notice] = "Rollen zijn gewijzigd"
    else
      flash[:error] = "Gebruiker is onbekend"
    end
    
    redirect_to users_path
  end
  
  def destroy
     @user = User.find(params[:id])
     @user.destroy
     flash[:notice] = "Gebruiker verwijderd"
     respond_to do |format|
       format.html { redirect_to(users_path) }
       format.xml  { head :ok }
     end
   end
end
