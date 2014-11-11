require 'csv'
module Carnival
  class BaseAdminController < InheritedResources::Base
    respond_to :html, :json
    layout "carnival/admin"

    def self.inherited(base)
      base.send(:defaults, instance_name: 'model')
      model_name = base.name.split('::').last.gsub('Controller', '').singularize
      base.send(:defaults, resource_class: model_name.constantize)
    end

    def home

    end

    def table_items
      nil
    end

    def render_inner_form
      @model_presenter = presenter_name(params[:field]).new controller: self
      model_class = params[:field].classify.constantize
      @model_object = model_class.send(:find_by_id, params[:id])
    end

    def presenter_name field
      field_name =  field.split('/').last
      carnival_mount = Carnival::Config.mount_at
      "#{carnival_mount}/#{field_name.singularize}_presenter".classify.constantize
    end

    def index
      @presenter = instantiate_presenter
      @query_form = Carnival::QueryFormCreator.create(@presenter, params)
      @model = instantiate_model(@presenter)
      base_query = table_items || @model
      @query_service = Carnival::QueryService.new(base_query, @presenter, @query_form)

      respond_to do |format|
        format.html do |render|
          @records = @query_service.get_query
          last_page = @query_service.total_records/@presenter.items_per_page
          @paginator = Carnival::Paginator.new @query_form.page, last_page
          @thead_renderer = Carnival::TheadRenderer.new @presenter.fields_for_action(:index), @query_form.sort_column, @query_form.sort_direction
          render 'index' and return
        end
        format.csv do
          @records = @query_service.records_without_pagination
          render :csv => t("activerecord.attributes.#{@presenter.full_model_name}.csv_name") , :template => 'carnival/base_admin/index.csv.haml' and return
        end
        format.pdf do
          @records = @query_service.records_without_pagination
          @thead_renderer = Carnival::TheadRenderer.new @presenter.fields_for_action(:index), @query_form.sort_column, @query_form.sort_direction
          render :pdf => t("activerecord.attributes.#{@presenter.full_model_name}.pdf_name") , :template => 'carnival/base_admin/index.pdf.haml',  :show_as_html => params[:debug].present? and return
        end
      end
    end

    def show
      @model_presenter = instantiate_presenter
      show! do |format|
        format.html do |render|
          render 'show' and return
        end
      end
    end

    def new
      @model_presenter = instantiate_presenter
      new! do |format|
        format.html do |render|
          render 'new' and return
        end
      end
    end

    def edit
      @model_presenter = instantiate_presenter
      edit! do |format|
        format.html do |render|
          render 'edit' and return
        end
      end
    end

    def create
      @model_presenter = instantiate_presenter
      create! do |success, failure|
        success.html{ redirect_to @model_presenter.model_path(:index), :notice => I18n.t("messages.created") and return}
        failure.html do |render|
          render 'new' and return
        end
      end
    end

    def update
      @model_presenter = instantiate_presenter
      update! do |success, failure|
        success.html{ redirect_to @model_presenter.model_path(:index), :notice => I18n.t("messages.updated") and return}
        failure.html do |render|
          render 'edit' and return
        end
      end
    end

    def render_popup partial
      @application_modal = partial
      render '/carnival/shared/render_popup' and return
    end

    def load_dependent_select_options
      presenter = params[:presenter].constantize.send(:new, :controller => self)
      model = presenter.relation_model(params[:field].gsub("_id", "").to_sym)
      @options = model.list_for_select(add_empty_option: true, query: ["#{params[:dependency_field]} = ?", params[:dependency_value]])
      render layout: nil
    end

    def load_select_options
      model_name = params[:model_name]
      search_field = params[:search_field]
      presenter = params[:presenter_name].constantize.send(:new, :controller => self)
      model = presenter.relation_model(model_name.to_sym)
      list = []
      model.where("#{search_field} like '%#{params[:q]}%'").each do |elem|
        list << {id: elem.id, text: elem.send(search_field.to_sym)}
      end

      render :json => list
    end
    private

    def instantiate_model(presenter)
      presenter.full_model_name.classify.constantize
    end

    def instantiate_presenter
      carnival_presenter_class.new controller: self
    end

    def carnival_presenter_class
      namespace = extract_namespace
      if namespace.present?
        "#{extract_namespace}::#{controller_name.classify}Presenter".constantize
      else
        "#{controller_name.classify}Presenter".constantize
      end
    end

    def extract_namespace
      namespace = ""
      arr = self.class.to_s.split("::")
      namespace = arr[0] if arr.size > 1
      namespace
    end
  end
end
