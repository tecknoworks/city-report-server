require 'sidekiq/web'

Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'web#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  post 'images' => 'images#create', as: 'image_upload'

  resources :issues
  put 'issues/:id/add_to_set' => 'issues#add_to_set'
  post 'issues/:id/vote' => 'issues#vote'

  if Repara.config['allow_downvotes']
    delete 'issues/:id/vote' => 'issues#vote'
  end

  if Repara.config['allow_delete_all']
    delete 'cleanup' => 'web#cleanup'
  end

  get 'meta' => 'web#meta'
  get 'doc' => 'web#doc'
  get 'up' => 'web#up'
  get 'eula' => 'web#eula'
  get 'about' => 'web#about'

  mount Sidekiq::Web, at: "/sidekiq"

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
