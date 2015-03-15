Carnival.configure do |config|
  Rails.application.config.assets.precompile += %w( carnival/* )
  config.menu = {
    admin: {
      label: 'aaa',
      class: 'ssss',
      link: 'ddd',
      subs: [
        {
          label: 'menu.testes',
          class: 'tst',
          link: '/admin/testes'
        },
        {
          label: '55555',
          class: '66666',
          link: '777777'
        }
      ]
    }
  }

  # Custom CSS Files
  # config.custom_css_files = ["samplefile.css"]

  # Custom Javascript Files
  # config.custom_javascript_files = ["samplefile.js"]

  # Determine root action
  # config.root_action = 'carnival/admin_users#index'

  config.use_full_model_name = false
end
