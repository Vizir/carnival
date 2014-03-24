# -*- encoding : utf-8 -*-
module Admin
  class CityPresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show], :sortable => false,
          :searchable => true,
          :advanced_search => {:operator => :equal}
    field :name,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}
    field :state,
          :actions => [:index, :new, :edit, :show], :as => :admin_relationship_select,
          :advanced_search => {:operator => :like}
    field :country,
          :actions => [:index, :new, :edit, :show], :as => :admin_relationship_select,
          :advanced_search => {:operator => :like}
    field :created_at, :actions => [:index, :show],
          :date_filter => true, :date_filter_default => :this_month,
          :date_filter_periods => {:today => ["#{Date.today}", "#{Date.today}"],
                                  :last_3_days => ["#{Date.today - 4.day}", "#{Date.today - 1.day}"],
                                  :yesterday => ["#{Date.today - 1.day}", "#{Date.today - 1.day}"],
                                  :this_week => ["#{Date.today.beginning_of_week}", "#{Date.today.end_of_week}"],
                                  :last_week => ["#{(Date.today - 1.week).beginning_of_week}", "#{(Date.today - 1.week).end_of_week}"],
                                  :this_month => ["#{Date.today.beginning_of_month}", "#{Date.today.end_of_month}"],
                                  :last_month => ["#{(Date.today - 1.month).beginning_of_month}", "#{(Date.today - 1.month).end_of_month}"],
                                  :this_year => ["#{Date.today.beginning_of_year}", "#{Date.today.end_of_year}"],
                                  :last_year => ["#{(Date.today - 1.year).beginning_of_year}", "#{(Date.today - 1.year).end_of_year}"]
          }
    field :updated_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    scope :all, :default => true
    scope :national
    scope :international

  end
end
