module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :omniauth, :omniauth_providers, :custom_css_files, :custom_javascript_files
    @@menu
    @@devise_config
    @@omniauth
    @@omniauth_providers
    @@custom_css_files = []
    @@custom_javascript_files = []
  end
end
