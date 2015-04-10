class Admin::TodoPresenter < Carnival::BaseAdminPresenter

  field :id, actions: [:index, :show]

  field :title,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal }

  field :status,
        actions: [:index, :new, :show, :edit],
        advanced_search: { operator: :equal },
        as: :carnival_enum

  field :todo_list,
        actions: [:new, :edit]

  field 'todo_list.name',
        actions: [:index, :show],
        advanced_search: { operator: :like }

  scope :todo, default: true
  scope :doing
  scope :done

  action :new
  action :show
  action :edit
  action :destroy
end
