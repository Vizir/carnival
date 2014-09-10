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
          :advanced_search => {:operator => :like},
          :show_view => 'name'
    field :code,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :states,
          :actions => [:show, :edit, :new],
          :nested_form => true, :nested_form_allow_destroy => true, :nested_form_modes => [:new],
          :relation_column => 'name'
    field :cities,
          :actions => [:show, :edit, :new],
          :nested_form => true, :nested_form_allow_destroy => true,
          :relation_column => 'name'
    field :created_at, :actions => [:index, :show]
    field :updated_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new
  end
end
