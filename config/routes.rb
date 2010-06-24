ActionController::Routing::Routes.draw do |map|

  map.resources :tasks do |task|
    task.resources :messages, :only => [:index, :new, :create], :controller => 'task_messages'
    task.resource :cancellation, :only => :create, :controller => 'task_cancellations'
  end

  map.resources :procedures, :shallow => true do |procedures|
    procedures.resources :instructions, :only => [:index, :new, :create], :controller => 'procedure_instructions'
  end

  map.resources :start_instructions, :as => :start, :path_prefix => 'instructions', :only => :index
  map.resources :instructions, :shallow => true, :except => [:new, :create] do |instructions|
    instructions.resources :messages, :only => [:new, :create], :controller => 'instruction_messages'
  end

  map.resources :messages do |messages|
    messages.resource :delivery, :only => :create, :controller => 'message_delivery'
  end

  map.root :controller => 'home'

end
