class Admin::PostPresenter < Carnival::BaseAdminPresenter
  field :id, actions: [:index, :new, :show, :edit]

  action :new
  action :show
  action :edit
end
