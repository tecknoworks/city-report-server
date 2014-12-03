require 'sidekiq/web'

Rails.application.routes.draw do
  apipie
  root 'web#index'

  post 'images' => 'images#create', as: 'image_upload'

  resources :issues, :only => [:index, :show, :create, :update]
  put 'issues/:id/add_to_set' => 'issues#add_to_set'
  post 'issues/:id/vote' => 'issues#vote'

  if Repara.config['allow_downvotes']
    delete 'issues/:id/vote' => 'issues#vote'
  end

  if Repara.config['allow_delete_all']
    delete 'cleanup' => 'web#cleanup'
  end

  get 'meta' => 'web#meta'
  get 'up' => 'web#up'
  get 'eula' => 'web#eula'
  get 'about' => 'web#about'

  mount Sidekiq::Web, at: "/sidekiq"
end
