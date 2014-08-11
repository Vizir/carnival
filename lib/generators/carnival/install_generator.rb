module Carnival
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install the Carnival Engine"
      source_root File.expand_path("../templates", __FILE__)

      def install
        route "mount_carnival_at 'admin'"
        template "../../../../config/locales/carnival.en.yml", "config/locales/carnival.en.yml"
        template "../../../../config/locales/carnival.pt-br.yml", "config/locales/carnival.pt-br.yml"
        template "../../../../config/locales/devise.pt-br.yml", "config/locales/devise.pt-br.yml"
        template "../../../../config/locales/devise.en.yml", "config/locales/devise.en.yml"
        template "carnival_initializer.rb", "config/initializers/carnival_initializer.rb"
      end
    end
  end
end
