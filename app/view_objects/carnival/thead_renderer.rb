module Carnival
  class TheadRenderer

    def initialize fields, sort_column, sort_direction
      @fields = fields
      @sort_column = sort_column.to_sym
      @sort_direction = sort_direction
    end


    def columns
      columns = []
      @fields.each do |key, field|
        column = {
          field: field,
          name: field.name,
          sort_dir: sort_dir(field),
          sort_function: sort_function(field),
          class: css_class(field)
        }
        columns << column
      end
      columns
    end

    def css_class field
      return 'sorting_disabled' if !field.sortable?

      if field.name.to_sym == @sort_column
        return "sorting_#{@sort_direction.to_s}"
      else
        return 'sorting'
      end
    end

    def sort_function field
      return '' if !field.sortable?
      sort_direction = sort_dir field
      "Carnival.sortColumn('#{field.name}', '#{sort_direction}')"
    end

    def sort_dir field
      sort_direction = 'asc'
      if field.name.to_sym == @sort_column
       sort_direction = 'desc' if @sort_direction == 'asc'
      end
      sort_direction
    end


  end
end
