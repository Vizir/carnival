module Carnival
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install the Carnival Engine"
      def install
        route "mount_my_engine_at 'admin'"
        rake 'carnival_engine:install:migrations'
        copy_file "../../../config/locales/carnival.en.yml", "config/locales/carnival.en.yml"
        copy_file "../../../config/locales/carnival.pt.yml", "config/locales/carnival.pt.yml"
        copy_file "../../../lib/initializers/carnival/carnival_initializer.rb", "config/initializers/carnival_initializer.rb"
      end
    end
  end
end
