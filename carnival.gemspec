$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "carnival/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "carnival"
  s.version     = Carnival::VERSION
  s.authors     = ["Vizir Software Studio"]
  s.email       = ["contato@vizir.com.br"]
  s.homepage    = "https://github.com/Vizir/carnival"
  s.summary     = "Carnival is an easy-to-use and extensible Rails Engine to speed the development of data management interfaces."
  s.description = "Carnival is an easy-to-use and extensible Rails Engine to speed the development of data management interfaces. When you use Carnival you can benefit from made features that are already done. If you need to change anything, you can write your own version of the method, using real Ruby code without worrying about the syntax of the engine."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.0"

  s.add_dependency "coffee-rails", '>= 4.0.0'
  s.add_dependency "haml-rails", '>= 0.7.0'
  s.add_dependency "inherited_resources", '>= 1.5.1'
  s.add_dependency "jquery-rails"
  s.add_dependency "simple_form", '~> 3.1.0'
  s.add_dependency "unicode", '>= 0.4.4.2'
  s.add_dependency "wicked_pdf", "~> 0.11.0"
  s.add_dependency "will_paginate", "~> 3.0.7"

  s.add_development_dependency "better_errors", "~> 0.9.0"
  s.add_development_dependency "binding_of_caller", "~> 0.7.2"
  s.add_development_dependency "bullet", "~> 4.14.0"
  s.add_development_dependency "byebug", "~> 3.4.0"
  s.add_development_dependency "capybara", "~> 2.4.4"
  s.add_development_dependency "factory_girl_rails", "~> 4.5.0"
  s.add_development_dependency "pry-byebug", "~> 2.0.0"
  s.add_development_dependency "poltergeist", "~> 1.5.1"
  s.add_development_dependency "rspec-rails", "~> 3.1.0"
  s.add_development_dependency "simplecov", "~> 0.9.1"
  s.add_development_dependency "sqlite3", "~> 1.3.10"
end
