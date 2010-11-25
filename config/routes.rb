ActionController::Routing::Routes.draw do |map|

  map.resources :notifiers do |notifier|
    notifier.resources :notifications, :only => :create
  end


  #
  # Organization namespace is for receiving http messages from other organizations.
  # Organization id is used to verify against the registered certificates.
  #
  map.resources :organizations, :only => [] do |organization|
    organization.resources :receptions, :only => :create
    organization.resources :deliveries, :only => [] do |message|
      message.resource :confirmation, :only => :create
    end
  end

  map.resources :receptions, :only => [:index, :show]

  map.resource :identity
  
  map.resources :jobs, :only => :index, :member => {:retry => :put}

  map.resources :castables
  map.resources :deliveries, :only => [:index, :show]
  map.resources :deliveries, :only => [:create], :controller => 'message_deliveries'
  map.resources :processings

  map.devise_for :users
  map.resources :users, :only => [:index, :update, :destroy] # FOR THE MAINAINTER ONLY!
  map.resources :workers, :only => [:index, :create, :show, :destroy]
  map.resources :user_sessions, :only => [:update, :destroy]

  map.resources :transaction_initiations, :as => :initiations, :path_prefix => 'transactions', :only => [:new, :create]
  map.resources :transaction_cancellations, :as => :cancellations, :path_prefix => 'transactions', :only => :create
  map.resources :transactions, :only => [:index, :show, :new, :create] do |transaction|
    transaction.resources :messages, :only => [:index, :new, :create], :controller => 'transaction_messages'
    transaction.resource :cancellation, :only => :create, :controller => 'transaction_cancellations'
  end

  map.resources :messages, :except => [:new, :destroy], :requirements => { :id => /[0-9]+/ } do |messages|
    messages.resources :deliveries, :only => [:create, :index], :controller => 'message_deliveries'
    messages.resources :replies, :only => [:new, :create], :controller => 'message_replies'
    messages.resources :steps, :only => :index
  end
  
  map.root :controller => 'home'
  
  map.connect 'soap/:action', :controller => 'soap'
  map.connect 'soap/:action/:id', :controller => 'soap'
  
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

end
