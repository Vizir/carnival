require "rubygems"
require "devise"
require "simple_form"
require "inherited_resources"
require "will_paginate"
# require "omniauth-facebook"
# require "omniauth-google-oauth2"
require "carnival/engine"
require "carnival/config"
require "carnival/routes"
require "carnival/version"
require "paperclip"
module Carnival

  def self.configure
    yield(Carnival::Config)       
  end
end
