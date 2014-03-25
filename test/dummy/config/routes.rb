Rails.application.routes.draw do
  mount_carnival_at 'admin'

  namespace :admin do
    resources :testes
    resources :countries
    resources :states
    resources :cities
    resources :people
    resources :companies
    resources :jobs
    resources :professional_experiences
  end
end
