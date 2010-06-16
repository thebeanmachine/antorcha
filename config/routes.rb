ActionController::Routing::Routes.draw do |map|

  map.resources :messages, :member => {:receive => :get }

  map.resources :steps, :shallow => true do |steps|
    steps.resources :messages, :only => [:new, :create], :controller => 'step_messages'
  end

end
