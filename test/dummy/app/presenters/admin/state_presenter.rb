# -*- encoding : utf-8 -*-
module Admin
  class StatePresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show], :sortable => false,
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

    field :country,
          :actions => [:index, :new, :edit, :show],
          :advanced_search => {:operator => :equal}
    field :cities,
          :actions => [:index, :show, :edit, :new],
          :nested_form => true, 
          :nested_form_allow_destroy => true, 
          nested_form_modes: [:new, :associate => {scope: :country}]


    field :created_at, :actions => [:index, :show],
          :date_filter => true
    field :updated_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    scope :all
    scope :national, :default => true
    scope :international

  end
end
