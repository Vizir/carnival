Carnival.configure |config| do
  config.menu = 
  {
    :admin => {
          :label => "aaa",
          :class => "ssss",
          :link => "ddd",
          :subs => [
            {
              :label => "menu.testes",
              :class => "tst",
              :link => "/admin/testes"
            },
            {
              :label => "55555",
              :class => "66666",
              :link => "777777"
            }
          ]
    },
    :locations => {
      :label => "menu.locations",
      :class => "",
      :link => "#",
      :subs => [
        {
          :label => "menu.countries",
          :class => "countries",
          :link => "/admin/countries"
        },
        {
          :label => "menu.states",
          :class => "states",
          :link => "/admin/states"
        },
        {
          :label => "menu.cities",
          :class => "cities",
          :link => "/admin/cities"
        }
      ]
    }
  }
  config.devise_config = :registerable, :recoverable, :rememberable, :trackable, :validatable,
                                   :omniauthable

  config.omniauth_providers = [:facebook, :google_oauth2]

  config.omniauth = {facebook: ["324810390938005", "3c16625e74189a3708cc586dc050a6b2"],
                              google_oauth2: ['431077382019-mumumjahr5cn6cooubtskc6ohael7923.apps.googleusercontent.com', 'ilH4B-KXN3tqG6qF9gGN1F_J']}

  # Custom CSS Files
  # config.custom_css_files = ["samplefile.css"]

  # Custom Javascript Files
  # config.custom_javascript_files = ["samplefile.js"]

  # Determine the super class of AdminUser
  #config.ar_admin_user_class = ActiveRecord::Base

  # Determine root action
  #config.root_action = 'carnival/admin_users#index'
end
