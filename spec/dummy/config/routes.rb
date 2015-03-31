Rails.application.routes.draw do
  mount_carnival_at :admin

  namespace :admin do
    resources :posts
    resources :todos
  end

  root to: 'admin/todos#index'
end
