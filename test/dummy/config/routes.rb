Rails.application.routes.draw do
  #mount Carnival::Engine => "/carnival"
  mount_my_engine_at "admin"
end
