RailsOnForum::Application.routes.draw do
  resources :topics
  resources :community_services
  resources :communities
  resources :community_news
  resources :activities
  #get 'photos/create'

  #scope '/foodiegroup' do
  get 'groups/show'
  mount ChinaCity::Engine => '/china_city'
  get 'drag_drop', to: 'home#drag_drop', as: :drag_drop

  resources :user_addresses
  resources :logistics
  resources :photos, only: [:create, :destroy, :index, :new]

  get 'tags/create'

  
  get 'tags/update'

  get 'tags/destroy'

  post 'topics/more_comments', to: 'topics#more_comments'

  namespace :admin do
    resources :reports
      #post "downorder", :on=>:collection
      post "/downorder", to:'reports#downorder'
      get '/users_list', to: 'reports#users_list'
      get '/groupbuys_list', to: 'reports#groupbuys_list'
      get '/topics_list', to: 'reports#topics_list'
      get '/participants_list', to: 'reports#participants_list'
      get '/tags_list', to: 'reports#tags_list'

      post '/set_online_offline', to: 'reports#set_online_offline', as: :set_online_offline

    end

    resource :votes, only: :create
    resources :tags, only: [:create, :update, :destroy]

    #mount Ckeditor::Engine => '/ckeditor'
    
    get    '/login',     to: 'sessions#new',     as: :login
    delete '/logout', to: 'sessions#destroy', as: :logout
    resource  :session, only: :create

    resource :search

    resources :forums  do
      resources :topics, only: [:new, :create]
    end

    resources :topics, except: [:index, :new, :create]  do
      resources :comments, only: [:new, :create,:index]
    end 


    resources :comments, only: [:edit, :update, :destroy]


    resources :users,   only: [:create, :update, :destroy] do
     resources :user_instetests
   end
   get '/users', to: 'users#index'

   
   get '/wechat_notify_url', to: 'participants#wechat_notify_url'
   get '/register',    to: 'users#new',  as: :register
   get '/:id',         to: 'users#show', as: :profile
   get '/:id/edit', to: 'users#edit', as: :edit_profile
   get '/:id/user_info', to: 'users#user_info', as: :user_info


   get '/sessions/auto_login', to: 'sessions#auto_login', as: :wx_auto_login
   get '/sessions/callback', to: 'sessions#callback', as: :wx_callback


   resource :home, only: [:index]
   root to: 'community_news#index'

  #end
end
