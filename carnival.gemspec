$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "carnival/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "carnival"
  s.version     = Carnival::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Carnival."
  s.description = "TODO: Description of Carnival."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.4"

  s.add_development_dependency "sqlite3"
end
