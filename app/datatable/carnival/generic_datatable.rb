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

    def initialize(view, model, controller, presenter)
      @view = view
      @model = model
      @controller = controller
      @presenter = presenter
      @filters = []
      @should_include_relation = !@model.is_a?(ActiveRecord::Relation)
    end

    def as_html(options = {})
      get_data(RENDER_TABLE)
    end

    def as_csv(options = {})
      data_to_csv(get_data(RENDER_CSV))
    end

    def as_json(options = {})
      count = records.count
      return_data = {}
      return_data[:data] = get_data

      scope_counters = @presenter.scopes.keys.map do |scope|
        count = records(false).send(scope.to_sym).size
        { scope: scope, count: count }
      end

      {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: count,
        iTotalDisplayRecords: records.total_entries,
        aaData: return_data[:data],
        scope_counters: scope_counters
      }
    end

    def as_pdf(options = {})
      records
    end

    def as_list(options = {})
      items = []
      model_object = params[:model_class_name].classify.constantize.send(:new)
      if !params[:model_id].empty?
        model_object = params[:model_class_name].classify.constantize.send(:find, params[:model_id])
      end
      if params[:carnival_list_scope]
        items = records.where(params[:carnival_list_scope])
      else
        items = records.all
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

  #private

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
            if i > 1
              if field[1].respond_to? :gsub
                csv_line << field[1].gsub(/\n$/, "") 
              else
                csv_line << field[1]
              end
            end
            i = i + 1
          end
          csv << csv_line
        end
      end
    end

    def get_data(render_type = RENDER_TABLE)
      records.map do |record|
        build_table_row(record, render_type)
      end
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
        if @presenter.has_batch_actions?
          data_item[i.to_s] = @controller.render_to_string :formats => [:html] , :partial => 'carnival/shared/batch_action_checkbox', :locals => {:modelo_presenter => @presenter,:item=> record, :only_render_fields => (render_type != RENDER_TABLE )}
          i = i + 1
        end
        @presenter.fields_for_action(:index).each do |key, field|
          data_item[i.to_s] = list_cel(@presenter, key,record, false)
          i = i + 1
        end
        data_item[i.to_s] = list_buttons(@presenter, record)
        i = i + 1
      end

      data_item
    end

    def records(apply_scope = true)
      @filters = []
      records = @model
      if(params[:scope].present? && params[:scope] != "all" && apply_scope)
        records = records.send(params[:scope])
        add_filter 'Escopo',params[:scope]
      end

      date_filter_field = @presenter.date_filter_field
      if(date_filter_field.present? && params[:from].present? && params[:from] != "" && params[:to].present? && params[:to] != "")
        records = records.where("#{@presenter.table_name}.#{date_filter_field.name} between ? and ?", "#{params[:from]} 00:00:00", "#{params[:to]} 23:59:59")
        add_filter 'Período',"#{params[:from]} - #{params[:to]}"
      end

      records = records.order("#{sort_column} #{sort_direction}")
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
        records = includes_relations(records) if @should_include_relation
        records = records.where(filtros.join(" or "), search: "%#{params[:sSearch]}%")
      end

      if @should_include_relation
        includes_relations(records)
      else 
        records
      end
    end

    def includes_relations(records)
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
      fields = @presenter.fields_for_action(:index)
      if fields.size > 0
        columns =  fields.map {|k, v| k.to_s}
      end
        
      column_index = params[:iSortCol_0].to_i
      column_index = column_index - 1 if @presenter.has_batch_actions?

      column = columns[column_index]
      if @presenter.relation_field? column.to_sym
        "#{column.pluralize}.name"
      else
        "#{@presenter.table_name}.#{column}"
      end
    end

    def sort_direction
      return 'desc' if params[:sSortDir_0] == 'desc'
      'asc'
    end
  end
end
