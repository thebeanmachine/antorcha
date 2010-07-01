ActionController::Routing::Routes.draw do |map|
  map.resources :organizations

  map.resources :roles


  map.resources :workers, :only => [:index, :create, :show, :destroy]
  map.resources :user_sessions, :only => [:update, :destroy]

  map.resources :transaction_initiations, :as => :initiations, :path_prefix => 'transactions', :only => [:new, :create]
  map.resources :transaction_cancellations, :as => :cancellations, :path_prefix => 'transactions', :only => :create
  map.resources :transactions do |transaction|
    transaction.resources :messages, :only => [:index, :new, :create], :controller => 'transaction_messages'
    transaction.resource :cancellation, :only => :create, :controller => 'transaction_cancellations'
  end

  map.resources :definitions, :shallow => true do |definitions|
    definitions.resources :steps, :only => [:index, :new, :create], :controller => 'definition_steps'
  end

  map.resources :start_steps, :as => :start, :path_prefix => 'steps', :only => :index
  map.resources :steps, :shallow => true, :except => [:new, :create] do |steps|
    steps.resources :messages, :only => [:new, :create], :controller => 'step_messages'
  end

  map.resources :messages do |messages|
    messages.resource :delivery, :only => :create, :controller => 'message_delivery'
  end

  map.root :controller => 'home'

end
