# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate_user!

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #
  # Current user is a user without roles.
  #
  
  def flash_notice action, model
    flash[:notice] = t("notice.#{action}", :model => model.class.human_name)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.activated?
      flash[:error] = exception.message
      redirect_to messages_path
    else
      #session should be cleared?
      render :text => "<p>U staat geregisteerd om te worden geactiveerd</p> TODO!"
    end
    # render :text => current_user.activated?
    # if current_user.active?
    #   flash[:error] = exception.message
    #   redirect_to messages_path
    # else      
    #   render :text => "U ben nog niet geactiveerd. Kom later terug!"
    # end
      
    # if current_user.is_not_registerd_at_all!?
    #   redirect_to new_user_registration
    # else
    #   if current_user.is_a_communicator?
    #     redirect_to messages_path
    #   else
    #     redirect_to silly_page_explaining_registered_users_have_to_be_activated
    #   end
    # end
    # render :text => exception.message
  end
  
end
