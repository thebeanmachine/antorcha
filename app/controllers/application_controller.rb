# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate_user!

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
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
      redirect_to "/registered.html"
    end
  end
  
end
