# -*- encoding : utf-8 -*-
module Admin
  class CountryPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show, :csv, :pdf], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :code,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :states,
          :actions => [:index, :show, :edit, :new],
          :nested_form => true, :nested_form_allow_destroy => true
    field :cities,
          :actions => [:index, :show, :edit, :new],
          :nested_form => true, :nested_form_allow_destroy => true
    field :created_at, :actions => [:index, :show]
    field :updated_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new
  end
end
