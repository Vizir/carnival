module Carnival

  class Config
    mattr_accessor :menu, :devise_config, :omniauth, :omniauth_providers
    @@menu
    @@devise_config
    @@omniauth
    @@omniauth_providers
  end

end
