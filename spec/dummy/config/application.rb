require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)
require "carnival"

module Carnival
  class Application < Rails::Application
    config.i18n.available_locales = :en
    config.i18n.default_locale = :en
    console { config.console = Pry }
  end
end

