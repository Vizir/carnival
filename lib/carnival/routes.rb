module ActionDispatch::Routing
  class Mapper
    def mount_my_engine_at(mount_location)
      scope mount_location do
        get 'admin/admin_user_notification/read/:id' => 'admin/admin_user_notifications#read', as: :admin_read_admin_user_notification
        resources :admin_user_notifications, controller: "admin/admin_user_notifications", :as => :admin_admin_user_notifications
        resources :admin_users, controller: "admin/admin_users", :as => :admin_admin_users
        devise_for :admin_users, :class_name => "Carnival::AdminUser", :path => "admin/sessions", :controllers => { :sessions => "admin/sessions", :omniauth_callbacks => "admin/omniauth_callbacks" }
        root to: "admin/admin_users#index", :as => :admin_root
      end
    end
  end
end
