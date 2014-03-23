module ActionDispatch::Routing
  class Mapper
    def mount_my_engine_at(mount_location)
      scope mount_location do
        get 'carnival/admin_user_notification/read/:id' => 'carnival/admin_user_notifications#read', as: :admin_read_admin_user_notification
        resources :admin_user_notifications, controller: "carnival/admin_user_notifications", :as => :admin_admin_user_notifications
        resources :admin_users, controller: "carnival/admin_users", :as => :admin_admin_users
        devise_for :admin_users, :class_name => "Carnival::AdminUser", :path => "carnival/sessions", :controllers => { :sessions => "carnival/sessions", :omniauth_callbacks => "carnival/omniauth_callbacks" }
        root to: "carnival/admin_users#index", :as => :admin_root
      end
    end
  end
end
