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

      query_form
    end


  end
end
