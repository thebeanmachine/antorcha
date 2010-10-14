# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :authenticate_user!

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :private_key
  
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
  
  rescue_from "ActiveResource::ResourceNotFound" do |exception|
    render :status => 503, :file => "public/503.html"
  end
  rescue_from "ActiveResource::ServerError" do |exception|
    render :status => 503, :file => "public/503.html"
  end      
end
