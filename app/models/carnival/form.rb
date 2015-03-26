module Carnival
  class Form

    attr_accessor :action,:params,:fields

    def initialize(action, params={})
      @params = params
      @action = action
    end

    def fields=(fields)
      @fields = fields
    end

    def lines
      ordered_lines
    end

    private

    def ordered_lines
      put_line_in_fields
      sort_columns(to_line_array)
    end

    def to_line_array
      lines = @fields.sort_by { |k, v| v.line }
      final_lines = []
      line_temp = []
      current_line = lines.first[1].line if lines.size > 0
      lines.each do |k,field|
        if current_line != field.line
          #Nova Linha
          final_lines << line_temp if line_temp.size > 0
          line_temp = []
          current_line = field.line
        end
        line_temp << field
      end
      final_lines << line_temp if line_temp.size > 0
      final_lines
    end

    def sort_columns (lines)
      lines.each do | line|
        line = line.sort_by{|x| x.column}
        check_size line
      end
      lines
    end

    def check_size (line)
      line_size = 0
      nil_values = 0
      line.each do |column|
        if column.size.present?
          line_size += column.size
        else
          nil_values += 1
        end
      end
      if nil_values > 0
        nil_column_size = 12 - (line_size / nil_values)
        line.each do |column|
          column.size = nil_column_size if not column.size.present?
        end
      end
    end

    def put_line_in_fields
      default_line = 999
      @fields.each do |key,field|
        if field.params[:position].blank? or field.params[:position][:line].blank?
          field.line = default_line
          default_line += 1
        end
      end
    end

  end

end
