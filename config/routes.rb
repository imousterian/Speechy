Rails.application.routes.draw do

  resources :students
  resources :student_responses, only: [:create,:new]

  # get 'static_pages/home'


  resources :tags

  # root :to => redirect('/contents')

  # resources :contents, :path_names => { :set_new_content => 'new' }

  # get '/contents/set_new_content', to: redirect('/contents/new')


    scope 'contents' do
         get 'tags/:tagname', :to => 'contents#summary', :as => 'summary'
         # put 'update_ctype',  :to => 'contents#update_ctype', :as => 'summary_update'
    end


  resources :contents do
    collection do
        # get "summary"
        # get  "set_new_content", :as => :set_new_content
        post "set_new_content", :action => :create
    end
  end

  root :to => "static_pages#home"

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

  match '/help', to: "static_pages#help", via: 'get'
  match '/about', to: "static_pages#about", via: 'get'
  match '/contact', to: "static_pages#contact", via: 'get'

  match 'selected_tags_for_students', to: "contents#selected_tags_for_students", via: 'get'

  get 'students/:id/show_response' => "students#show_response", as: "show_response"
  get 'students/:id/show_summary' => "students#show_summary", as: "show_summary"
  get 'students/:id/show_graph' => "students#show_graph", as: "show_graph"

  match '/sign_in_guest', to: "application#create_guest_user", via: 'get'


  # match '/test', to: "students#new", via: 'get'



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
