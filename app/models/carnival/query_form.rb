module Carnival
  class QueryForm
    attr_accessor :scope, :search_term, :advanced_search, :date_period_from, :date_period_to, :sort_column_index, :items_per_page

    def initialize(params)
      @scope = params[:scope]
      @search_term = params[:search_term]
      @advanced_search = params[:advanced_search]
      @date_period_from = params[:date_period_from]
      @date_period_to = params[:date_period_to]
      @sort_column_index = params[:sort_column_index]
      @page = params[:page]
    end

    def page
      return 1 if @page.nil?
      @page.to_i
    end
  end
end
