# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include SwiftHelper
  help_can_link_to :user
  help_can_link_to :castable
  help_can_link_to :deliveries

  
  def index_title
    content_tag :h1, t([:titles, controller.controller_name, :index].join('.'))
  end

  # one for all, all for one
  def musketeer *values
    values.join '' unless values.include? nil
  end
  
  def crumble *models
    models.inject [] do |memo, model|
      last = Array(memo.last)
      memo << last + [model.class] unless model.kind_of? Class
      memo << last + [model] 
    end
  end
  
  def shallow_crumble paths
    crumbles = paths.inject([]) {|m,p| m << crumble(*p) }
    polynate(crumbles)
  end

  def polynate crumbles
    crumbles.inject do |memo, path|
      if path.first.last.kind_of? Class
        memo << (memo.last + [path.shift.last])
      end
      memo += path
    end
  end
  
  def arrayize *models
    models.inject [[]] do |memo, model|
      if model.kind_of? Array
        memo << model << []
      else
        memo.last << model
      end
      memo
    end.reject &:blank?
  end
  
  def breadcrumb *models
    @content_for_breadcrumb = shallow_crumble(arrayize(*models)).collect do |route|
      last = route.last
      poly_path = route.map {|part| part.kind_of?(Class) ? part.name.underscore.pluralize.to_sym : part}
      if last.kind_of? Class
        link_to last.human_name(:count => 3), poly_path
      else
        link_to last.title, poly_path
      end
    end.join(" » ")
  end
  
end
