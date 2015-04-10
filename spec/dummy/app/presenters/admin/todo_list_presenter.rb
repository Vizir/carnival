class Admin::TodoListPresenter < Carnival::BaseAdminPresenter

  field :id, actions: [:index, :show]

  field :name,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal }

  action :new
  action :show
  action :edit
  action :destroy
end
