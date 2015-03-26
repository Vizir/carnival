module ActionDispatch::Routing
  class Mapper
    def mount_carnival_at(mount_location)
      Carnival::Config.mount_at = mount_location
      get "/carnival/load_select_options" => 'carnival/base_admin#load_select_options', as: :load_select_options
      scope mount_location do
        get "carnival-base/load_dependent_select_options/:presenter/:field/:dependency_field/:dependency_value" => 'carnival/base_admin#load_dependent_select_options', as: :load_dependent_select_options
        get "render_inner_form" => 'carnival/base_admin#render_inner_form' 
        root to: Carnival::Config.root_action, :as => :carnival_root
      end
    end
  end
end
