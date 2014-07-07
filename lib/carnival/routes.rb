module ActionDispatch::Routing
  class Mapper
    def mount_carnival_at(mount_location)
      scope mount_location do
        get "carnival-base/load_dependent_select_options/:presenter/:field/:dependency_field/:dependency_value" => 'carnival/base_admin#load_dependent_select_options', as: :load_dependent_select_options
        get "admin_user_notification/read/:id" => 'carnival/admin_user_notifications#read', as: :carnival_read_admin_user_notification
        resources :admin_user_notifications, controller: "carnival/admin_user_notifications", :as => :carnival_admin_user_notifications
        resources :admin_users, controller: "carnival/admin_users", :as => :carnival_admin_users
        if Carnival::Config.devise_config.include?(:omniauthable) and Carnival::Config.omniauth.present?
          devise_for :admin_users, :class_name => "Carnival::AdminUser", :path => "sessions", :controllers => { :sessions => "carnival/sessions", :omniauth_callbacks => "carnival/omniauth_callbacks" }
        else
          devise_for :admin_users, :class_name => "Carnival::AdminUser", :path => "sessions", :controllers => { :sessions => "carnival/sessions"}
        end
        root to: Carnival::Config.root_action, :as => :admin_root
      end
    end
  end
end
