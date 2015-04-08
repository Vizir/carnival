Rails.application.routes.draw do
  mount_carnival_at :admin

  namespace :admin do
    resources :posts
    resources :todos
    resources :todo_lists
  end

  root to: 'admin/todos#index'
end
