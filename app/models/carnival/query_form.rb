module Carnival
  class QueryForm
    attr_accessor :scope, :search_term, :date_period_label, :date_period_from, :date_period_to, :sort_column, :sort_direction

    def initialize(params)
      @scope = params[:scope]
      @search_term = params[:search_term]
      @advanced_search = params[:advanced_search]
      @date_period_label = params[:date_period_label]
      @date_period_from = params[:date_period_from]
      @date_period_to = params[:date_period_to]
      @sort_column = params[:sort_column]
      @sort_direction = params[:sort_direction]
      @page = params[:page]
    end

    def advanced_search
      return '' if @advanced_search.nil? 
      @advanced_search
    end

    def to_hash
      params = {} 
      self.instance_variables.each do |var|
        var_name = var.to_s.gsub('@', '')
        params[var_name] = self.send(var_name)
      end
      params
    end

    def page
      return 1 if @page.nil?
      @page.to_i
    end
  end
end
