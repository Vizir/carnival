module Carnival::GenericDatatable
  class RelationColumnSorter < ColumnSorter
    def build_sort_string
      relation_column = @presenter.fields[@column].relation_column
      association_class = @presenter.relation_model(@column)
      "#{association_class.table_name}.#{relation_column}"
    end
  end
end
