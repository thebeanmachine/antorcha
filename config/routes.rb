ActionController::Routing::Routes.draw do |map|

  map.resources :messages do |messages|
    messages.resource :delivery, :only => :create, :controller => 'message_delivery'
  end

  map.resources :steps, :shallow => true do |steps|
    steps.resources :messages, :only => [:new, :create], :controller => 'step_messages'
  end

end
