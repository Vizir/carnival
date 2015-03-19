class Admin::TodoPresenter < Carnival::BaseAdminPresenter

  field :id, actions: [:index, :show]

  field :title,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal }

  field :status,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal },
        as: :carnival_enum

  scope :todo, default: true
  scope :doing
  scope :done

  action :new
  action :show
  action :edit
  action :destroy
end
