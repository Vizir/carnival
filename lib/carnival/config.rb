module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :omniauth, :omniauth_providers, :custom_css_files, :custom_javascript_files, :ar_admin_user_class, :root_action, :use_full_model_name, :app_name
    @@app_name = "#{Rails.application.class.to_s.split('::').first} Admin"
    @@menu
    @@devise_config = []
    @@omniauth
    @@omniauth_providers
    @@custom_css_files = []
    @@custom_javascript_files = []
    @@ar_admin_user_class = ActiveRecord::Base
    @@root_action = "carnival/admin_users#index"
    @@use_full_model_name = true
  end
end
