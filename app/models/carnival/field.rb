module Carnival
  class Field

    attr_accessor :size, :column, :line, :name, :params

    def initialize(name, params={})
      @params = params
      @name = name
      set_position_by_params
    end

    def name
      @name.to_s
    end

    def css_class
      if @params[:css_class]
        return @params[:css_class]
      else
        return ""
      end
    end

    def date_filter?
      @params[:date_filter]
    end

    def default_date_filter
      if @params[:date_filter_default]
        @params[:date_filter_default]
      else
        date_filter_periods.first.first
      end
    end

    def date_filter_periods
      if @params[:date_filter_periods]
        @params[:date_filter_periods]
      else
        {:today => ["#{Date.today}", "#{Date.today}"],
                                  :yesterday => ["#{Date.today - 1.day}", "#{Date.today - 1.day}"],
                                  :this_week => ["#{Date.today.beginning_of_week}", "#{Date.today.end_of_week}"],
                                  :last_week => ["#{(Date.today - 1.week).beginning_of_week}", "#{(Date.today - 1.week).end_of_week}"],
                                  :this_month => ["#{Date.today.beginning_of_month}", "#{Date.today.end_of_month}"],
                                  :last_month => ["#{(Date.today - 1.month).beginning_of_month}", "#{(Date.today - 1.month).end_of_month}"],
                                  :this_year => ["#{Date.today.beginning_of_year}", "#{Date.today.end_of_year}"],
                                  :last_year => ["#{(Date.today - 1.year).beginning_of_year}", "#{(Date.today - 1.year).end_of_year}"]
        }
      end
    end
    def default_sortable?
      @params[:sortable] && @params[:sortable].class == Hash && @params[:sortable][:default] == true
    end

    def default_sort_direction
      if default_sortable?
        if @params[:sortable][:direction]
          return @params[:sortable][:direction]
        end
      end
      return :asc
    end

    def nested_form?
      @params[:nested_form]
    end

    def nested_form_allow_destroy?
      @params[:nested_form_allow_destroy]
    end

    def nested_form_modes? (mode)
      @params[:nested_form_modes].include?(mode)
    end

    def sortable?
      @params[:sortable]
    end

    def searchable?
      @params[:searchable]
    end

    def advanced_searchable?
      @params[:advanced_search]
    end

    def advanced_search_operator
      return @params[:advanced_search][:operator] if advanced_searchable? and @params[:advanced_search][:operator].present?
      :like
    end

    def valid_for_action?(action)
      @params[:actions].include?(action)
    end

    def as
      @params[:as]
    end

    def widget
      @params[:widget].present? ? @params[:widget] : :input
    end

  private
    def set_position_by_params
      if @params[:position].present?
        @line = @params[:position][:line]
        @column =  @params[:position][:column]
        @size = @params[:position][:size]
      end
    end
  end
end
