module Admin
  class CreditCardPresenter < Carnival::BaseAdminPresenter

    field :id,
          :actions => [:index, :show], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}

    action :show
    action :edit
    action :destroy
    action :new

  end
end