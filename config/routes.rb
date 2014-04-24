Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :controllers => {:omniauth_callbacks => 'users/omniauth_callbacks'}
  devise_scope :user do 
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
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

  get '/auth/github' => 'auth#github', as: 'github_login'
  get '/auth/github/callback' => 'sessions#create', as: 'github_callback'


  post 'create_gem' => 'jems#gemify_jem', as: 'jemify_gem'
  post 'update_gem' => 'jems#gemify_updated_jem'
  get 'percentage_done' => 'jems#percentage_done', as: 'percentage_done'
  get 'get_gem_repo' => 'jems#get_gem_repo'
  post 'update_version' => 'jems#update_version'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
