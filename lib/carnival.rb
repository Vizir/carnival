require "rubygems"
require "simple_form"
require "inherited_resources"
require "will_paginate"
require "carnival/engine"
require "carnival/config"
require "carnival/routes"
require "carnival/version"
module Carnival

  def self.configure
    yield(Carnival::Config)       
  end
end
