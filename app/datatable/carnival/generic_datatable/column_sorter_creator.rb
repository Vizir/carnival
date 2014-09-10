module Carnival::GenericDatatable
  class ColumnSorterCreator
    def self.create_sorter(presenter, column)
      sorter = if presenter.relation_field?(column)
                 RelationColumnSorter
               else
                 ColumnSorter
               end
      sorter.new(presenter, column)
    end
  end
end
