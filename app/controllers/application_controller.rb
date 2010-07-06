# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #
  # Current user is a user without roles.
  #
  def current_user
    session[:user] ||= []
  end
  
  def authorize
    if current_user.include? :adviser
      true
    else
      flash[:error] = "Geen toegang. U bent geen adviseur"
      redirect_to root_url
      false
    end
  end
  
  def flash_notice action, model
    flash[:notice] = t("notice.#{action}", :model => model.class.human_name)
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  
end
