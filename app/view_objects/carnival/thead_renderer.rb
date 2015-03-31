module Carnival
  class TheadRenderer
    def initialize(fields, sort_column, sort_direction)
      @fields = fields
      @sort_column = sort_column.to_sym
      @sort_direction = sort_direction
    end

    def columns
      @fields.values.map do |field|
        {
          field: field,
          name: field.name,
          sort_dir: sort_dir(field),
          sort_function: sort_function(field),
          class: css_class(field)
        }
      end
    end

    def css_class(field)
      return 'sorting_disabled' unless field.sortable?

      if field.sort_name.to_sym == @sort_column
        "sorting_#{@sort_direction}"
      else
        'sorting'
      end
    end

    def sort_function(field)
      return '' unless field.sortable?
      sort_direction = sort_dir field
      "Carnival.sortColumn('#{field.sort_name}', '#{sort_direction}')"
    end

    def sort_dir(field)
      sort_direction = 'asc'
      if field.sort_name.to_sym == @sort_column
        sort_direction = 'desc' if @sort_direction == 'asc'
      end
      sort_direction
    end
  end
end
