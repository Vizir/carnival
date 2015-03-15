Carnival.configure do |config|
  Rails.application.config.assets.precompile += %w( carnival/* )
  config.menu = {
    administration: {
      label: 'administration',
      link: '/admin/customers',
      class: 'administracao',
      subs: [{
        label: 'posts',
        link: '/admin/posts'
      }]
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
