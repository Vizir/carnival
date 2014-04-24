module Admin
  class InstallmentPresenter < Carnival::BaseAdminPresenter

    field :id,
          :actions => [:index, :show], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :credit_cards,
          :actions => [:index, :show, :edit, :new],
          :nested_form => true, 
          :nested_form_allow_destroy => true,
          :nested_form_modes => [:associate]

    action :show
    action :edit
    action :destroy
    action :new

  end
end