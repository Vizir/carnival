module Admin
  class PersonHistoryPresenter < Carnival::BaseAdminPresenter


    field :history,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}


    action :show
    action :edit
    action :destroy
    action :new

  end
end
