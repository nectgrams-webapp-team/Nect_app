Rails.application.routes.draw do
  # get 'site_admins/admin_index', to: "site_admins#admin_index", as: "admin_index"
  #
  # get 'site_admins/member_editor', to: "site_admins#member_editor", as: "member_editor"
  # get 'site_admins/member_statistics', to: "site_admins#member_statistics", as: "member_statistics"
  # get 'site_admins/resend_invitation/:id', to: "site_admins#resend_invitation", as: "resend_invitation"
  # post "site_admins/increment_grade", to: "site_admins#increment_grade", as: "increment_grade"
  # post "site_admins/decrement_grade", to: "site_admins#decrement_grade", as: "decrement_grade"
  # patch 'grant_mod_status/:id', to: 'site_admins#grant_mod_status', as: 'grant_mod_status'
  # patch 'revoke_mod_status/:id', to: 'site_admins#revoke_mod_status', as: 'revoke_mod_status'
  # patch 'grant_admin_status/:id', to: 'site_admins#grant_admin_status', as: 'grant_admin_status'
  # patch 'revoke_admin_status/:id', to: 'site_admins#revoke_admin_status', as: 'revoke_admin_status'
  # delete 'site_admins/:id', to: "site_admins#destroy_member", as: "destroy_member"
  #
  # get 'site_admins/carousel_editor', to: "site_admins#carousel_editor", as: "carousel_editor"
  # post 'site_admins/create_image', to: 'site_admins#create_image', as: "create_image"
  # patch 'site_admins/update_image/:id', to: 'site_admins#update_image', as: "update_image"
  # delete 'site_admins/delete_image/:id', to: 'site_admins#delete_image', as: "delete_image"
  #
  # get 'site_admins/event_history_editor', to: 'site_admins#event_history_editor', as: 'event_history_editor'
  # post 'site_admins/create_event_history', to: 'site_admins#create_event_history', as: 'create_event_history'
  # patch 'site_admins/update_event_history/:id', to: 'site_admins#update_event_history', as: 'update_event_history'
  # delete 'site_admins/delete_event_history/:id', to: 'site_admins#delete_event_history', as: 'delete_event_history'

  namespace :site_admins do
    get 'admin_index', to: "site_admins#admin_index", as: "admin_index"

    # Member management routes
    resources :members, only: [:destroy] do
      member do
        get 'resend_invitation'
        patch 'grant_mod_status'
        patch 'revoke_mod_status'
        patch 'grant_admin_status'
        patch 'revoke_admin_status'
        delete 'destroy_member'
      end
      collection do
        get 'editor', to: "site_admins#member_editor", as: "editor"
        get 'statistics', to: "site_admins#member_statistics", as: "statistics"
        post 'increment_grade'
        post 'decrement_grade'
      end
    end

    # Carousel editor routes
    resources :carousel_images, only: [:index, :create, :update, :destroy], path: 'carousel' do
      collection do
        get 'editor', to: "site_admins#carousel_editor", as: "editor"
      end
    end

    # Event history editor routes
    resources :event_histories, only: [:index, :create, :update, :destroy], path: 'event_history' do
      collection do
        get 'editor', to: 'site_admins#event_history_editor', as: 'editor'
      end
    end
  end

  root to: "homes#top"
  get "homes/about", to: "homes#about", as: "about"

  devise_for :members, controllers: {
      invitations: 'members/invitations',
      registrations: 'members/registrations',
    }

  resources :members, only: [:index, :show, :edit, :update, :destroy]
  resources :activities

  namespace :api, path: 'api', format: :json do
    namespace :v1 do
      post '/activities/preview', to: 'activities#preview'
    end
  end

  resources :members, only: [:index, :show, :edit, :update]
  resources :teams
  resources :team_members

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
