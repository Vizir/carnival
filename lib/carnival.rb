require 'rubygems'
require 'simple_form'
require 'inherited_resources'
require 'carnival/engine'
require 'carnival/config'
require 'carnival/routes'
require 'carnival/version'
require 'haml-rails'
require 'will_paginate'
require 'csv'

module Carnival
  def self.configure
    yield(Carnival::Config)
  end
end
