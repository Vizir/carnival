module Carnival::GenericDatatable
  class ColumnSorter
    def initialize(presenter, column)
      @presenter = presenter
      @column = column
    end

    def build_sort_string
      "#{@presenter.table_name}.#{@column}"
    end
  end
end
