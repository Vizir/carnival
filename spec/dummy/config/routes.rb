Rails.application.routes.draw do
  mount_carnival_at :admin

  namespace :admin do
    resources :posts
  end

  root to: 'admin/posts#index'
end
