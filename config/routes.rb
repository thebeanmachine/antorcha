ActionController::Routing::Routes.draw do |map|
  map.resources :organizations

  map.resources :reactions

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
    definitions.resources :reactions, :controller => 'definition_reactions'
    definitions.resources :roles, :shallow => false
  end

  map.resources :start_steps, :as => :start, :path_prefix => 'steps', :only => :index
  map.resources :steps, :shallow => true, :except => [:new, :create] do |steps|
    steps.resources :messages, :only => [:new, :create], :controller => 'step_messages'
  end

  map.resources :messages, :except => :new, :requirements => { :id => /[0-9]+/ } do |messages|
    messages.resources :deliveries, :only => [:create, :index], :controller => 'message_deliveries'
    messages.resources :replies, :only => [:new, :create], :controller => 'message_replies'
  end

  map.root :controller => 'home'

end
