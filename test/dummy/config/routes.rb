Rails.application.routes.draw do
  #mount Carnival::Engine => "/carnival"
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

  mount_my_engine_at "admin"
end
