Rails.application.routes.draw do

    devise_for :users
    match '/users/:id', :to => 'users#show',    :as => :user,         :via => :get
    match '/users', :to => 'users#index',    :as => :users,         :via => :get
    match '/users/:id', :to => 'users#destroy', :as => :destroy_user, :via => :delete

    resources :students
    resources :student_responses, only: [:create,:new]
    # resources :tags, except: [:show]
    resources :contents, except: [:index, :show]

    get 'tags/:tag', to: 'static_pages#home', as: 'tugg'

    root :to => "static_pages#home"

    get 'users/:id/contents/summary_index', to: 'contents#summary_index', as: "summary_index"

    match '/help', to: "static_pages#help", via: 'get'
    match '/about', to: "static_pages#about", via: 'get'
    match '/contact', to: "static_pages#contact", via: 'get'

    get 'students/:id/show_response' => "students#show_response", as: "show_response"
    get 'students/:id/show_summary' => "students#show_summary", as: "show_summary"
    get 'students/:id/show_selected' => "students#show_selected", as: "show_selected"

    match '/sign_in_guest', to: "application#create_guest_user", via: 'get'

end
