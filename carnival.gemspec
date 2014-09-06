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
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "haml-rails"
  s.add_dependency "ckeditor"
  s.add_dependency "simple_form"
  s.add_dependency "inherited_resources"
  s.add_dependency "will_paginate"
  s.add_dependency 'wicked_pdf'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "bullet"
  s.add_development_dependency "binding_of_caller"
end
