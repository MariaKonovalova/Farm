FarmServer::Application.routes.draw do

  resources :element_types, :only => [:index]
  resources :elements, :only => [:index]
  resources :sessions, :only => [:create, :destroy]
  resources :plants, :only => [:index, :create]

=begin
  resources :plants do
    get 'growth_all', :on => collection
    #delete '', :on => member
  end

  resources :picture do
    get 'download', :on => collection
  end
=end

  #connect '', :controller => 'plants', :action => 'growth_all', :conditions => { :method => :get }

  #resources :plants, :collection => { :growth_all => :get }

  match 'plants/growth_all' => 'plants#growth_all'
  match 'plants/:id' => 'plants#destroy'

  #get 'plants/:id' => 'plants#destroy'
  #get 'plants/growth_all' => 'plants#growth_all'
  #get 'picture/download' => 'picture#download'

  #connect ':controller/:action/:id'
  #connect ':controller/:action/:id.:format'

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
  #root :to => 'say#hello'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
