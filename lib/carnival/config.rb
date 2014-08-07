module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :devise_class_name, :omniauth, :omniauth_providers, :custom_css_files, :custom_javascript_files, :root_action, :use_full_model_name, :app_name, :mount_at
    @@app_name
    @@mount_at
    @@menu
    @@devise_config = []
    @@omniauth
    @@omniauth_providers
    @@custom_css_files = []
    @@custom_javascript_files = []
    @@ar_admin_user_class = ActiveRecord::Base
    @@root_action = "carnival/admin_users#index"
    @@use_full_model_name = true
    @@devise_class_name = 'Carnival::AdminUser'

    def self.app_name
      return "#{Rails.application.class.to_s.split('::').first} Admin" if @@app_name.nil? 
      return @@app_name
    end
  end
end
