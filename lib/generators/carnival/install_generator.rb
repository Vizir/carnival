module Carnival
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install the Carnival Engine"
      source_root File.expand_path("../templates", __FILE__)

      def install
        route "mount_my_engine_at 'admin'"
        rake 'carnival_engine:install:migrations'
        puts Rails.root
        template "../../../config/locales/carnival.en.yml", "config/locales/carnival.en.yml"
        template "../../../config/locales/carnival.pt.yml", "config/locales/carnival.pt.yml"
        template "../../../config/locales/devise.pt.yml", "config/locales/devise.pt.yml"
        template "../../../config/locales/devise.en.yml", "config/locales/devise.en.yml"
        template "carnival_initializer.rb", "config/initializers/carnival_initializer.rb"
      end
    end
  end
end
