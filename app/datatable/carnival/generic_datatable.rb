# -*- encoding : utf-8 -*-
module Carnival
  class GenericDatatable
    delegate :params, :caminho_modelo, :h, :link_to, :number_to_currency, :number_with_precision, :list_cel, :list_buttons, to: :@view
    delegate :current_usuario, :render_to_string, to: :@controller
    attr_accessor :model, :presenter
    require 'csv'

    RENDER_TABLE = 0
    RENDER_CSV = 1
    RENDER_PDF = 2

    def initialize(view, model, controller, presenter, items=nil)
      @view = view
      @model = model
      @controller = controller
      @presenter = presenter
      @items = items
      @filters = []
    end

    def as_csv(options = {})
      data_to_csv(data(RENDER_CSV))
    end

    def as_json(options = {})
      if(params[:scope].present? && params[:scope] != "all")
        @model = @model.send(params[:scope])
      end

      date_filter_field = @presenter.date_filter_field
      if(date_filter_field.present? && params[:from].present? && params[:from] != "" && params[:to].present? && params[:to] != "")
        @model = @model.where("#{@presenter.table_name}.#{date_filter_field.name} between ? and ?", "#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59")
      end

      count = @model.count

      return_data = {}
      return_data[:data] = get_data
      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: count,
        iTotalDisplayRecords: records.total_entries,
        aaData: return_data[:data]
      }
    end

    def as_pdf(options = {})
      fetch_records
    end

    def as_list(options = {})
      items = []
      model_object = params[:model_class_name].classify.constantize.send(:new)
      if !params[:model_id].empty?
        model_object = params[:model_class_name].classify.constantize.send(:find, params[:model_id])
      end
      if params[:carnival_list_scope]
        items = @model.where(params[:carnival_list_scope])
      else
        items = @model.all
      end

      just_class_name = params[:model_class_name].demodulize.classify.underscore
      controller = params[:controller_name].constantize.new
      model_presenter = params[:presenter_name].constantize.new controller: controller
      field = model_presenter.fields[params[:field_name].to_sym]
      opt = Carnival::NestedFormOptions.new model_object, model_presenter, field, items
      html = render_to_string :partial => 'carnival/shared/form/nested_form_options.html.haml', :locals => { opt_obj: opt }
      return :template => html.to_s, :items => items
    end

    def filters
      @filters
    end

  private

    def data_to_csv(data)
      CSV.generate(:col_sep => "\t") do |csv|
        csv_line = []
        @presenter.fields_for_action(:csv).each do |key, field|
          csv_line << I18n.t("activerecord.attributes.#{@presenter.full_model_name}.#{field.name}")
        end
        csv << csv_line

        data.each do |line|
          i = 0
          csv_line = []
          line.each do |field|
            csv_line << field[1].gsub(/\n$/, "") if i > 1
            i = i + 1
          end
          csv << csv_line
        end
      end
    end

    def get_data(render_type = RENDER_TABLE)
      data = []
      records.each do |record|
        data << build_table_row(record, render_type)
      end
      data
    end

    def build_table_row record, render_type
      data_item = {
        "DT_RowId" => "item#{record.id}",
        "DT_RowClass" => "more-click"
      }

      i = 0

      if render_type == RENDER_CSV
        @presenter.fields_for_action(:csv).each do |key, field|
          data_item[i.to_s] = list_cel(@presenter, key,record, true)
          i = i + 1
        end
      elsif render_type == RENDER_PDF
        @presenter.fields_for_action(:pdf).each do |key, field|
          data_item[i.to_s] = list_cel(@presenter, key,record, true)
          i = i + 1
        end
      else render_type == RENDER_TABLE
        @presenter.fields_for_action(:index).each do |key, field|
          data_item[i.to_s] = list_cel(@presenter, key,record, false)
          i = i + 1
        end
        data_item[i.to_s] = list_buttons(@presenter, record)
        #data_item[i.to_s] = @controller.render_to_string :formats => [:html], :partial => '/carnival/shared/item_buttons', :locals => {:record=>record, :presenter => @presenter}
        i = i + 1
      end

      data_item
    end

    def records
      @records ||= fetch_records
    end

    def fetch_records
      @filters = []
      records = !@items.nil? ? @items : @model
      if(params[:scope].present? && params[:scope] != "all")
        records = records.send(params[:scope])
        add_filter 'Escopo',params[:scope]
      end

      date_filter_field = @presenter.date_filter_field
      if(date_filter_field.present? && params[:from].present? && params[:from] != "" && params[:to].present? && params[:to] != "")
        records = records.where("#{@presenter.table_name}.#{date_filter_field.name} between ? and ?", "#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59")
        add_filter 'Período',"#{params[:from]} - #{params[:to]}"
      end

      records = records.order("#{@presenter.table_name}.#{sort_column} #{sort_direction}")
      if params['format'] == 'json'
        records = records.page(page).per_page(per_page)
      end
      filtros = []
      if params[:advancedquery].present?
        records = @presenter.parse_advanced_search(records, params[:advancedquery])
        records = records.where(filtros.join(" or "), search: "%#{params[:sSearch]}%")
      elsif params[:sSearch].present? and @presenter.searchable_fields.size > 0
        @presenter.searchable_fields.each do |key, field|
          filtros << "#{key.to_s} like :search"
        end
        @presenter.join_tables.each do |relation_name|
          records = records.joins(relation_name)
        end
        #records = records.where(filtros.join(" or "), search: "%#{params[:sSearch]}%")
        records = records.where(filtros.join(" or "), search: "%#{params[:sSearch]}%")
      end
      @presenter.join_tables.each do |relation_name|
        records = records.includes(relation_name)
      end
      records
    end

    def add_filter(name,value)
      @filters << [name,value]
    end

    def page
      params[:iDisplayStart].to_i/per_page + 1
    end

    def per_page
      params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 50
    end

    def sort_column
      if @presenter.fields.size > 0
        columns =  @presenter.fields.map {|k, v| k.to_s}
      end
      columns[params[:iSortCol_0].to_i]
    end

    def sort_direction
      sort_dir = @presenter.default_sort_direction
      if params[:sSortDir_0].present?
        sort_dir = params[:sSortDir_0]
        sort_dir == "desc" ? "desc" : "asc"
      end

      if sort_dir == 'desc'
        return 'desc'
      else
        return 'asc'
      end
    end
  end
end
