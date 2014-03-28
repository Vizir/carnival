module ActionDispatch::Routing
  class Mapper
    def mount_carnival_at(mount_location)
      scope mount_location do
        get "admin_user_notification/read/:id" => 'carnival/admin_user_notifications#read', as: :carnival_read_admin_user_notification
        resources :admin_user_notifications, controller: "carnival/admin_user_notifications", :as => :carnival_admin_user_notifications
        resources :admin_users, controller: "carnival/admin_users", :as => :carnival_admin_users
        devise_for :admin_users, :class_name => "Carnival::AdminUser", :path => "sessions", :controllers => { :sessions => "carnival/sessions", :omniauth_callbacks => "omniauth_callbacks" }
        root to: "admin_users#index", :as => :admin_root
      end
    end
  end
end
