# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def index_title
    content_tag :h1, t([:titles, controller.controller_name, :index].join('.'))
  end
  
end
