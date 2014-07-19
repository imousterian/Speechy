Rails.application.routes.draw do
  resources :tags

  root :to => redirect('/contents')

  # resources :contents, :path_names => { :set_new_content => 'new' }

  # get '/contents/set_new_content', to: redirect('/contents/new')

  # resources :contents do
  #    resources: :tags
  # end

    scope 'contents' do
        get 'tags/:tagname', :to => 'contents#summary', :as => 'summary'
    end


  resources :contents do
    collection do
        # get "summary"
        # get  "set_new_content", :as => :set_new_content
        post "set_new_content", :action => :create
    end
  end


    # scope ":username" do
    #     get '/', to: 'users#show', as: 'user_name'
    #     get '/edit', to: 'users#edit', as: 'user_name_edit'
    # end

  # /contents/tagname
  devise_for :users

  devise_scope :user do
      # get "sessions/dropbox_callback", to: "devise/sessions#dropbox_callback"
      # match 'sessions/dropbox_callback', :controller => 'sessions', :action => 'dropbox_callback', via: :get
  end
    # get "sessions/dropbox_callback", to: "devise/sessions#dropbox_callback"

  get  "dropbox/authorize"
  get  "dropbox/dropbox_callback"
  get  "dropbox/upload"
  post "dropbox/upload"

  # match '/contents/set_new_content', to: "contents#set_new_content", via: 'get'

  # match 'sessions/dropbox_callback', :controller => 'sessions', :action => 'dropbox_callback', via: :get


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
