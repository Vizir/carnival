module Carnival
  module Presenters
    class AdvancedSearchParser

      def initialize(klass_service)
        @klass_service = klass_service
      end
       def get_advanced_search_fields fields
          advanced_search_fields = {}
          fields.each do |key, field|
            advanced_search_fields[key] = field if field.advanced_searchable?
          end
          advanced_search_fields
       end

       def parse_advanced_search fields, records, search_syntax
          search = search_syntax
          search.each do |key, value|
            search_field = key
            #search_field = key.split(".").last if key.include?(".")
            search_field = search_field.gsub("_id", "") if search_field.ends_with?("_id")
            next if !fields.keys.include? search_field.to_sym
            field = fields[search_field.to_sym]
            if field.advanced_searchable? && value.present? && value.size > 0
              field_param = {"operator" => field.advanced_search_operator.to_s, "value" => "#{value}"}
              records =  parse_advanced_search_field(search_field, field_param, records)
            end
          end
          records
       end

      private
        def parse_advanced_search_field search_field, field_param, records
          return records unless field_param["value"].present?
          return records if field_param["value"] == ""

          if search_field.is_a?(String) && search_field.include?('.')
            search_field_params = search_field.split('.')
            search_field = search_field_params[0]
            column = search_field_params[1]
          end

          if @klass_service.relation? search_field.to_sym
            if @klass_service.is_a_one_to_one_relation?(search_field.to_sym)
              records = records.joins(search_field.split("/").last.to_sym)
            else
              records = records.joins(search_field.split("/").last.pluralize.to_sym)
            end
            table = @klass_service.get_related_class(search_field.to_sym).table_name
            column = "id" if column.nil?
          else
            table = @klass_service.table_name
            column = search_field
          end
          
          records.where(where_clause(field_param, table, column))
        end

        def where_clause(field_param, table, column)
          arel_table = Arel::Table.new(table)
          operator = field_param['operator']
          value = field_param['value']
          value2 = field_param['value2']

          case operator
          when 'equal'
            if value == 'nil'
              arel_table[column].eq(nil)
            elsif value.match(/^\d+$/)
              arel_table[column].eq(value)
            else
              arel_table.lower(arel_table[column]).eq("#{advanced_search_field_value_for_query(value)}")
            end
          when 'like'
            arel_table.lower(arel_table[column]).matches("%#{value.downcase}%")
          when 'greater_than'
            arel_table[column].gteq(value)
          when 'less_than'
            arel_table[column].lteq(value)
          when 'between'
            Arel::Nodes::Between.new(
              arel_table[column], Arel::Nodes::And.new([value, value2])
            )
          else
            arel_table[column].eq("#{advanced_search_field_value_for_query(value)}")
          end
        end

        def advanced_search_field_value_for_query(value)
          if "true" == value.downcase
            return "'t'"
          elsif "false" == value.downcase
            return "'f'"
          end

          value.downcase
        end
    end
  end
end
