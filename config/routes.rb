Rails.application.routes.draw do
  get 'dojos/new'  => 'dojos#new'
  get 'new' => 'dojos#new'
# students controller:
  # NOTE THAT WE DO NOT WRITE THIS ROUTE:
  # get 'dojos/:id' => 'dojos#show', as: 'dojo'
  # BECAUSE NESTING BELOW WILL FORWARD ALL ROUTES ('dojos/:id' to 'dojos#show' view)...
  resources :dojos, only: [:show] do
    resources :students, except: [:index, :create], controller: 'dojos/students'
    # THE CONTROLLER SPECIFYING OPTION IS REQUIRED ABOVE (ELSE RAILS DOES NOT FIND 'students' CONTROLLER)
    # Add on other options separated by a ',':
    # EX: resources :students, except: [:index, :create], controller: 'dojos/students'
    # (...will make our app look to a specific path, within dojos folder, for the controller file)
  end 
  get 'dojos/:id/students' => 'dojos#show'
  post 'dojos/:id/students', to: 'dojos/students#create'
# get '/dojos/:dojo_id/student/:id', to: 'dojos/students#profile'

# dojos controller:
  get 'dojos/index'
  get 'index', to: 'dojos#index'
  root 'dojos#index'
  get 'dojos' => 'dojos#index'
  post 'dojos', to: 'dojos#create'
  get 'dojos/:id/edit' => 'dojos#edit', as: 'edit_dojo'
  delete 'dojos/:id' => 'dojos#destroy', as: 'destroy_dojo'
  patch 'dojos/:id' => 'dojos#update', as: 'update_dojo'
  
  # students controller:
  # get 'dojos/:dojo_id/students' => 'dojos#show' #might want to chage to :id to route back to dojos controller.  
  # get 'dojos/:dojo_id/students/new' => 'students#new'
  # get 'dojos/:dojo_id/students/:id' => 'students#profile'
  # get 'dojos/:dojo_id/students/:id/edit' => 'students#edit'
  # post 'dojos/:dojo_id/students' => 'students#create'
  # patch 'dojos/:dojo_id/students/:id' => 'students#update'
  # delete 'dojos/:dojo_id/students/:id' => 'students#destroy'

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
