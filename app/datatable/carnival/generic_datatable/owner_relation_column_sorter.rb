module Carnival::GenericDatatable
  class OwnerRelationColumnSorter < ColumnSorter
    def build_sort_string
      owner_relation = @presenter.fields[@column].owner_relation
      association_class = @presenter.relation_model(owner_relation)
      "#{association_class.table_name}.#{@column}"
    end
  end
end
