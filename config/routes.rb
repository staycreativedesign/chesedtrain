Rails.application.routes.draw do
  resources :updates
  resources :events do
    resources :event_dates
    resources :updates
  end

  resources :chesed_trains do
    member do
      get 'steps/:step', to: 'chesed_trains#steps', as: :steps
      patch 'update_step'
      post 'update_step'
      get 'thank-you', to: 'chesed_trains#thank_you', as: :thank_you
    end

    resources :event_dates do
      member do
        get '/new-volunteer/', to: 'selections#volunteer', as: :volunteer
        post '/new-volunteer/',  to: 'selections#setup_volunteer', as: :setup_volunteer
        patch '/add-volunteer/', to: 'selections#add_volunteer', as: :add_volunteer
      end
    end
  end

  resources :potlucks do
    member do
      get 'steps/:step', to: 'potlucks#steps', as: :steps
      patch 'update_step'
      get 'thank-you', to: 'potlucks#thank_you', as: :thank_you
    end

    resources :selections do
      member do
        get '/new-volunteer/', to: 'selections#volunteer', as: :volunteer
        post '/new-volunteer/',  to: 'selections#setup_volunteer', as: :setup_volunteer
        patch '/add-volunteer/', to: 'selections#add_volunteer', as: :add_volunteer
      end
    end
  end

  resource :session
  resources :passwords, param: :token
  resources :users
  get '/pro', to: 'home#pro', as: :pro
  # get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  # get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  get '/select-chesed-type', to: 'selection#new', as: :selection
  get '/about-us', to: 'home#about', as: :about
  get '/contact-us', to: 'contact#new', as: :new_contact
  get '/contact-thank-you', to: 'contact#thank_you', as: :contact_thank_you
  post '/contact-us', to: 'contact#create', as: :contact
  get '/privacy-policy', to: 'home#privacy_policy', as: :privacy_policy
  get '/terms-of-services', to: 'home#tos', as: :tos
  get '/sign-in', to: 'sessions#new', as: :login
  get '/coming-soon', to: 'home#coming_soon', as: :coming_soon

  get 'signup', to: 'registrations#new'
  post 'signup', to: 'registrations#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
  get 'select-chesed', to: 'home#select_chesed', as: 'select_chesed'
end
