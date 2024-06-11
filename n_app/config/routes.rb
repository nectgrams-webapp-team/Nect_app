Rails.application.routes.draw do
  get 'site_admins/member_editor', to: "site_admins#member_editor", as: "member_editor"
  get 'site_admins/admin_index', to: "site_admins#admin_index", as: "admin_index"
  patch 'grant_admin_status/:id', to: 'site_admins#grant_admin_status', as: 'grant_admin_status'
  patch 'revoke_admin_status/:id', to: 'site_admins#revoke_admin_status', as: 'revoke_admin_status'
  delete 'site_admins/:id', to: "site_admins#destroy", as: "destroy"
  root to: "homes#top"
  get "homes/about", to: "homes#about", as: "about"

  devise_for :members, controllers: {
      invitations: 'members/invitations'
    }

  resources :members, only: [:index, :show, :edit, :update, :destroy]
  resources :activities
  resources :teams
  resources :team_members

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
