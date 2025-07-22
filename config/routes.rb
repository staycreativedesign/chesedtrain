Rails.application.routes.draw do
  get 'errors/not_found'
  resources :updates
  resources :events do
    resources :event_dates
    resources :updates
  end
  get 'create_payment_link', to: 'payments#create_payment_link'
  post '/success', to: 'payments#success'
  get '/payment-success', to: 'payments#payment_success'
  get '/chesed-train-pro-account', to: 'payments#pro', as: :pro_account
  get 'chesed-train-pro/', to: 'payments#new', as: :new_payment
  post 'ads/:id/track', to: 'ads#track', as: 'track_ad'
  match '/404', to: 'errors#not_found', via: :all

  resources :chesed_trains do
    member do
      get 'steps/:step', to: 'chesed_trains#steps', as: :steps
      patch 'update_step'
      post 'update_step'
      get 'thank-you', to: 'chesed_trains#thank_you', as: :thank_you
      get '/shabbat', to: 'yom_tovs#index', as: :yom_tovs
    end

    resources :event_dates do
      member do
        get '/new-volunteer/', to: 'selections#volunteer', as: :volunteer
        post '/new-volunteer/',  to: 'selections#setup_volunteer', as: :setup_volunteer
        patch '/add-volunteer/', to: 'selections#add_volunteer', as: :add_volunteer

        resources :yom_tovs, except: [:index] do
          member do
            get '/new-volunteer/:selection_id', to: 'selections#volunteer', as: :volunteer
            post '/new-volunteer/:selection_id',  to: 'selections#setup_volunteer', as: :setup_volunteer
            patch '/add-volunteer/:selection_id', to: 'selections#add_volunteer', as: :add_volunteer
          end
        end
      end
    end
  end

  resources :potlucks do
    member do
      get 'steps/:step', to: 'potlucks#steps', as: :steps
      patch 'update_step'
      post 'update_step'
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

  namespace :admin do
    resource :dashboard
    resources :users
    resources :chesed_trains
    resources :potlucks
    resources :events
    resources :ads
    get 'reports/users_report', to: 'reports#users_report', defaults: { format: 'xlsx' }, as: :users_report
    get 'reports/ads_report', to: 'reports#ads_report', defaults: { format: 'xlsx' }, as: :ads_report
    get 'reports/potlucks_report', to: 'reports#potluck_events_report', defaults: { format: 'xlsx' },
                                   as: :potluck_reports
    get 'reports/chesed_events_report', to: 'reports#chesed_events_report', defaults: { format: 'xlsx' },
                                        as: :chesed_train_reports
  end

  resource :session
  resources :passwords, param: :token
  resources :users do
    member do
      get '/unsubscribe', to: 'payments#unsubscribe', as: :unsubscribe
      post '/unsubscribe_action', to: 'payments#unsubscribe_action', as: :unsubscribe_action
    end
  end
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
  resources :password_resets, only: %i[new create edit update]

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
