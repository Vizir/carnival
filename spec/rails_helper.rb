ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'byebug'
require 'capybara-webkit'
require 'factory_girl_rails'
require 'rspec/rails'
require 'simplecov'

Dir[File.expand_path('spec/support/**/*.rb'), __FILE__].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit
SimpleCov.start { add_filter 'vendor/' }

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end
silence_stream(STDOUT) { load "#{Rails.root.join('db/schema.rb')}" }
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/factories"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include Features::IndexHelpers, type: :feature

  config.include FactoryGirl::Syntax::Methods
end
