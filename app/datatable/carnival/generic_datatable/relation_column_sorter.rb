module Carnival::GenericDatatable
  class RelationColumnSorter < ColumnSorter
    def build_sort_string
      field = @presenter.get_field(@column)
      association_class = @presenter.relation_model(field)
      "#{association_class.table_name}.#{field.association_field_name}"
    end
  end
end
