ActionController::Routing::Routes.draw do |map|

  map.resources :procedures, :shallow => true do |procedures|
    procedures.resources :instructions, :only => [:new, :create], :controller => 'procedure_instructions'
  end

  map.resources :instructions, :shallow => true, :except => [:new, :create] do |instructions|
    instructions.resources :messages, :only => [:new, :create], :controller => 'instruction_messages'
  end

  map.resources :messages do |messages|
    messages.resource :delivery, :only => :create, :controller => 'message_delivery'
  end

  map.root :controller => 'home'

end
