module Carnival
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def install
        run 'bundle install'
        route "mount Carnival::Engine => '/admin'"
        rake 'carnival_engine:install:migrations'
      end
    end
  end
end
