module Carnival
  class QueryFormCreator

    def self.create presenter, params
      query_form = Carnival::QueryForm.new(params)

      if query_form.sort_column.nil?
        query_form.sort_column = presenter.default_sortable_field.name.to_sym
      end

      if query_form.sort_direction.nil?
        query_form.sort_direction = presenter.default_sort_direction
      end

      if query_form.date_period_label.nil?
        date_filter_field = presenter.date_filter_field
        query_form.date_period_label = date_filter_field.default_date_filter if date_filter_field.present?
      end

      query_form
    end


  end
end
