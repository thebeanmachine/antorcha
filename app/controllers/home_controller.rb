class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    if user_signed_in?
      redirect_to messages_url
    else
      redirect_to new_user_session_url
    end
  end
end