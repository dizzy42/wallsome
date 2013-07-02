Wallsome::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  resource :user
  resource :verification
  resource :password
  resources :basecamp_users
  resources :basecamp_accounts, :only => [:index]

  scope '/:basecamp_account_name' do
    match 'projects/:project_id/todo_items/dialog', :to => "todo_items#dialog", :as => :todo_item_dialog
    match 'projects/:project_id/todo_lists/dialog', :to => "todo_lists#dialog", :as => :todo_list_dialog
    get 'projects/:project_id/todo_lists/reorder',
        :to => "reorder_todo_lists#edit",
        :as => :edit_project_reorder_todo_lists
    put 'projects/:project_id/todo_lists/reorder',
        :to => "reorder_todo_lists#update",
        :as => :project_reorder_todo_lists

    resources :projects do
      resource :backlog, :only => [:show]
      resources :milestones do
        get 'current', :on => :collection
        resources :todo_lists
      end
      resource :columns, :only => [:edit, :update]
    end

    resources :todo_lists do
      resources :todo_items do
        put :move, :on => :member
      end
    end

    resources :todo_items do
      resources :comments
    end
  end

  # Convenience
  match "/login", :to => "sessions#new", :as => :login
  match "/logout", :to => "sessions#destroy", :as => :logout
  match "/signup", :to => "users#new", :as => :signup
  match "/help", :to => "miscellaneous#help", :as => :help

  match "/subscriptions/activations_notifications",
        :to => "activations_notifications#create",
        :via => :post
  match "/subscriptions/deactivations_notifications",
        :to => "deactivations_notifications#create",
        :via => :post
  match "/subscriptions/failed_notifications",
        :to => "failed_notifications#create",
        :via => :post

  # Temporary workaround
  # TODO: Remove when 37signals update their link to us
  # from beta.wallsome.com to www.wallsome.com
  match "/" => redirect(WALLSOME_SITE_BASE_URL)

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "basecamp_accounts#show"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
