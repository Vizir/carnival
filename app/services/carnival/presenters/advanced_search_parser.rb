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
          search = JSON.parse(search_syntax)
          search.keys.each do |key|
            search_field = key
            #search_field = key.split(".").last if key.include?(".")
            search_field = search_field.gsub("_id", "") if search_field.ends_with?("_id")
            next if !fields.keys.include? search_field.to_sym
            if fields[search_field.to_sym].advanced_searchable?
              records =  parse_advanced_search_field(search_field, search[key], records)
            end
          end
          records
       end

      private
        def parse_advanced_search_field search_field, field_param, records
          return records if not field_param["value"].present?
          return records if field_param["value"] == ""
          if search_field.is_a?(String) && search_field.include?('.')
            search_field_params = search_field.split('.')
            search_field = search_field_params[0]
            column = search_field_params[1]
          end
          if @klass_service.relation? search_field.to_sym
            related_model = @klass_service.get_related_class(search_field.to_sym).name.underscore
            foreign_key = @klass_service.get_foreign_key(search_field.to_sym)
            if @klass_service.is_a_belongs_to_relation?(search_field.to_sym)
              records = records.joins(related_model.split("/").last.to_sym)
            else
              records = records.joins(related_model.split("/").last.pluralize)
            end
            table = related_model.split("/").last.classify.constantize.table_name
            column = "id" if column.nil? || field_param["operator"] == "equal"
          else
            table = @klass_service.table_name
            column = search_field
          end
          full_column_query = "#{table}.#{column}"
          where_clause = nil

          case field_param["operator"]
            when "equal"
              if field_param["value"] == "nil"
                where_clause = "#{full_column_query} is null"
              else
                where_clause = "#{full_column_query} = '#{advanced_search_field_value_for_query(field_param["value"])}'"
              end
            when "like"
              where_clause = "#{full_column_query} like '%#{field_param["value"]}%'"
            when "greater_than"
              where_clause = "#{full_column_query} >= '#{field_param["value"]}'"
            when "less_than"
              where_clause = "#{full_column_query} <= '#{field_param["value"]}'"
            when "between"
              where_clause = "#{full_column_query} between '#{field_param["value"]}' and '#{field_param["value2"]}'"
            else
              where_clause = "#{full_column_query} = #{advanced_search_field_value_for_query(field_param["value"])}"
          end
          records = records.where(where_clause) if where_clause.present?
          records
        end

        def advanced_search_field_value_for_query(value)
          if "true" == value.downcase
            return "'t'"
          elsif "false" == value.downcase
            return "'f'"
          else
            "#{value}"
          end
        end


    end
  end
end
