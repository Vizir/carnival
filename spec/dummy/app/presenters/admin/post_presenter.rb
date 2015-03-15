class Admin::PostPresenter < Carnival::BaseAdminPresenter
  field :id, actions: [:index, :show]
  field :title,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal }

  field :content, actions: [:new, :show, :edit]

  action :new
  action :show
  action :edit
  action :destroy
end
