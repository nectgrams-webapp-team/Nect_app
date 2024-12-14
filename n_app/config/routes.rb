Rails.application.routes.draw do
  root to: 'homes#top'
  get 'homes/about', to: 'homes#about', as: 'about'

  devise_for :members, controllers: {
    invitations: 'members/invitations',
    registrations: 'members/registrations',
  }

  resources :members, only: [:index, :show, :edit, :update, :destroy]

  # resources :activities
  resources :activities do
    post 'save_draft', on: :collection
    patch 'change_publish', on: :member
  end

  namespace :api, path: 'api', format: :json do
    namespace :v1 do
      post '/activities/preview', to: 'activities#preview'
      get 'members/courses_by_department', to: 'members#courses_by_department'
    end
  end

  resources :members, only: [:index, :show, :edit, :update]
  resources :activities
  resources :teams
  resources :team_members

  namespace :site_admins do
    get 'index', to: "base#index", as: 'index'
    resources :carousel_images, :event_histories, only: [:index, :create, :update, :destroy]
    resources :members_manager, only: [:index, :destroy] do
      member do
        get 'resend_invitation'
        patch 'grant_mod_status'
        patch 'revoke_mod_status'
        patch 'grant_admin_status'
        patch 'revoke_admin_status'
      end
      collection do
        get 'statistics', to: 'members_manager#statistics', as: 'statistics'
        post 'increment_grade'
        post 'decrement_grade'
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
