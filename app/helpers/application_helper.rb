# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def index_title
    content_tag :h1, t([:titles, controller.controller_name, :index].join('.'))
  end

  # one for all, all for one
  def musketeer *values
    values.join '' unless values.include? nil
  end
  
end
