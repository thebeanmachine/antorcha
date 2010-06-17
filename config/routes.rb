ActionController::Routing::Routes.draw do |map|

  map.resources :tasks, :shallow => true do |tasks|
    tasks.resources :steps, :only => [:new, :create], :controller => 'task_steps'
  end

  map.resources :steps, :shallow => true, :except => [:new, :create] do |steps|
    steps.resources :messages, :only => [:new, :create], :controller => 'step_messages'
  end

  map.resources :messages do |messages|
    messages.resource :delivery, :only => :create, :controller => 'message_delivery'
  end

end
