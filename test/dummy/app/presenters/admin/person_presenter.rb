# -*- encoding : utf-8 -*-
module Admin
  class PersonPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :csv, :pdf, :show], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal},
          :position => {line: 1, size: 2}
    field :name,
          :actions => [:index, :csv, :pdf, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like},
          :position => {line: 1, size: 6},
          :css_class => "test-css-custom"
    field :email,
          :actions => [:index, :csv, :pdf, :new, :edit, :show],
          :advanced_search => {:operator => :like},
          :position => {line: 1}
    field :country,
          :actions => [:index, :csv, :pdf, :new, :edit, :show], :as => :admin_relationship_select,
          :advanced_search => {:operator => :equal},
          :position => {line: 2, size: 3}
    field :state,
          :actions => [:index, :csv, :pdf, :new, :edit, :show],
          :advanced_search => {:operator => :equal},
          :position => {line: 2, size: 3},
          :depends_on => :country
    field :city,
          :actions => [:index, :csv, :pdf, :new, :edit, :show],
          :advanced_search => {:operator => :equal},
          :position => {line: 2, size: 3},
          :depends_on => :state
    field :zipcode,
          :actions => [:new, :csv, :pdf, :edit, :show],
          :position => {line: 2, size: 3}
    field :address,
          :actions => [:new, :csv, :pdf, :edit, :show],
          :position => {line: 3, size: 5}
    field :number,
          :actions => [:new, :csv, :pdf, :edit, :show],
          :position => {line: 3, size: 2}
    field :address_complement,
          :actions => [:new, :csv, :pdf, :edit, :show],
          :position => {line: 3, size: 5}
    field :employed,
          :actions => [:index, :csv, :pdf, :new, :edit, :show],
          :advanced_search => {:operator => :like},
          :position => {line: 4, size: 4}
    field :professional_experiences,
          :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    scope :all, :default => true
    scope :employed
    scope :unemployed

  end
end
