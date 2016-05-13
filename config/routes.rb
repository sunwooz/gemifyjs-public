Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'}
  devise_scope :user do
    get '/auth/github/callback' => 'sessions#create', as: :github_callback
    get '/auth/github' => 'auth#github', as: 'github_login'
    delete 'sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: 'static#index'
  get 'jems/all' => 'static#show', as: 'show_jem'

  get 'jems/new' => 'jems#new', as: 'new_jem'
  get 'jems/:id' => 'jems#show', as: 'jem'
  get 'jems' => 'jems#index', as: 'jems'
  post 'jems' => 'jems#create'
  get 'jems/:id/edit' => 'jems#edit', as: 'edit_jem'
  patch 'jems/:id' => 'jems#update'
  delete 'jems/:id' => 'jems#destroy', as: 'delete_jem'

  post 'jems/:id/scripts' => 'scripts#create', as: 'new_script'
  get 'jems/:id/scripts/:script_id' => 'scripts#show', as: 'script'
  delete 'script/:id' => 'scripts#destroy', as: 'delete_script'

  post 'create_gem' => 'jems#gemify_jem', as: 'jemify_gem'
  post 'update_gem' => 'jems#gemify_updated_jem'
  get 'percentage_done' => 'jems#percentage_done', as: 'percentage_done'
  get 'get_gem_repo' => 'jems#get_gem_repo'
  post 'update_version' => 'jems#update_version'

end
