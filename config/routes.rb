Apptwit::Application.routes.draw do
	
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  
  # get '/signup' => 'users#new', :as => "signup"
  match '/signup',  :to => 'users#new', :as => "signup"
  match '/signin',  :to => 'sessions#new', :as => "signin"
  match '/signout', :to => 'sessions#destroy', :as => "signout"
  match 'pages/contact', :to => 'pages#contact', :as => "contact"
  match '/pages/about',   :to => 'pages#about', :as => "about"
  match 'pages/help',    :to => 'pages#help', :as => "help"
  match 'pages/home',    :to => 'pages#home', :as => "home"
  match '/', :to => 'pages#home'
  root :to => 'pages#home'
  
  
# WHAT ENTRY resources :users ACTUALLY PROVIDES:
# HTTP request	URL	       Action	  Named route	     Purpose
# GET	      /users	       index	  users_path	     page to list all users
# GET	      /users/1	     show	    user_path(1)	   page to show user with id 1
# GET	      /users/new     new	    new_user_path	   page to make a new user (signup)
# POST	      /users	     create	  users_path	     create a new user
# GET	      /users/1/edit  edit	    edit_user_path(1)  page to edit user with id 1
# PUT	      /users/1	     update	  user_path(1)	   update user with id 1
# DELETE      /users/1	   destroy	user_path(1)	   delete user with id 1
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  # root :to => 'pages#home'
 
  
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
