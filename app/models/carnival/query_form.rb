module Carnival
  class QueryForm
    attr_accessor :scope, :search_term, :date_period_label,
                  :date_period_from, :date_period_to, :sort_column,
                  :sort_direction, :page, :advanced_search

    def initialize(params)
      @scope = params[:scope]
      @search_term = params[:search_term]
      @date_period_label = params[:date_period_label]
      @date_period_from = params[:date_period_from]
      @date_period_to = params[:date_period_to]
      @sort_column = params[:sort_column]
      @sort_direction = params[:sort_direction]

      @advanced_search =
        params[:advanced_search].try(:to_unsafe_h) ||
        params[:advanced_search].try(:to_h) ||
        {}
      @page = (params[:page] || 1).to_i
    end

    def to_hash
      {
        'scope' => scope,
        'search_term' => search_term,
        'date_period_label' => date_period_label,
        'date_period_from' => date_period_from,
        'date_period_to' => date_period_to,
        'sort_column' => sort_column,
        'sort_direction' => sort_direction,
        'advanced_search' => advanced_search,
        'page' => page
      }
    end
  end
end
