ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'factory_girl'
require 'simplecov'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, { phantomjs: Rails.root.join('bin/phantomjs').to_s })
end
Capybara.javascript_driver = :poltergeist

SimpleCov.start do
  add_filter 'vendor/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'
  add_filter '/vagrant/'
  add_filter '/test/'
end

Dir.glob(Rails.root.join('spec/factories/**/*.rb')).each {|factory| require factory }
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/stubs/**/*.rb")].each { |f| require f }

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
silence_stream(STDOUT) { load "#{Rails.root.join('db/schema.rb')}" }

Devise.stretches = 1
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include Features::AuthenticationHelper, type: :feature
  config.include Features::RegexHelper, type: :feature
  config.include Devise::TestHelpers, type: :controller
  config.include Controllers::ApiAuthenticationHelper, type: :controller
end
