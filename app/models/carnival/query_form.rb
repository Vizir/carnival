module Carnival
  class QueryForm
    attr_accessor :scope, :search_term, :advanced_search, :date_period_from, :date_period_to, :order_column, :items_per_page, :page

    def initialize(params)
      scope = params[:scope]
      search_term = params[:search_term]
      advanced_search = params[:advanced_search]
      date_period_from = params[:date_period_from]
      date_period_to = params[:date_period_to]
      order_column = params[:order_column]
      items_per_page = params[:items_per_page]
      page = params[:page]
    end
  end
end