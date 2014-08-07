module Admin
  class PersonHistoryPresenter < Carnival::BaseAdminPresenter


    field :history,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :as => :ckeditor,
          :advanced_search => {:operator => :like}


    action :show
    action :edit
    action :destroy
    action :new

  end
end
