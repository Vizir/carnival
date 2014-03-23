module Carnival
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def install
        run 'bundle install'
        route "mount Carnival::Engine => '/admin'"
        rake 'carnival_engine:install:migrations'
        copy_file "../../../config/locales/carnival.en.yml", "config/locales/carnival.en.yml"
        copy_file "../../../config/locales/carnival.pt.yml", "config/locales/carnival.pt.yml"
        copy_file "../../../lib/initializers/carnival/carnival_initializer.rb", "config/initializers/carnival_initializer.rb"
      end
    end
  end
end
