require 'sidekiq/web'

Rails.application.routes.draw do
  root 'web#index'

  post 'images' => 'images#create', as: 'image_upload'

  if Repara.show_dashboard?
    resources :issues, :only => [:index, :show, :create, :update]
  else
    scope :format => true, :constraints => { :format => 'json' } do
      resources :issues, :only => [:index, :show, :create, :update]
    end
  end
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
end
