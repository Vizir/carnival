module Carnival
  class BaseAdminController < InheritedResources::Base
    respond_to :html, :json
    layout "carnival/admin"
    before_action :instantiate_presenter

    def home

    end

    def table_items
      nil
    end

    def render_inner_form
      @presenter = presenter_name(params[:field]).new controller: self
      model_class = params[:field].classify.constantize
      @model_object = model_class.find(params[:id])
    end

    def presenter_name field
      field_name =  field.split('/').last
      carnival_mount = Carnival::Config.mount_at
      "#{carnival_mount}/#{field_name.singularize}_presenter".classify.constantize
    end

    def index
      @query_form = Carnival::QueryFormCreator.create(@presenter, params)
      @model = @presenter.model_class
      @query_service = Carnival::QueryService.new(table_items || @model, @presenter, @query_form)

      respond_to do |format|
        format.html do
          @records = @query_service.get_query
          last_page = (@query_service.total_records / @presenter.items_per_page.to_f).ceil
          @paginator = Carnival::Paginator.new @query_form.page, last_page
          @thead_renderer = Carnival::TheadRenderer.new @presenter.fields_for_action(:index), @query_form.sort_column, @query_form.sort_direction
        end
        format.csv do
          @records = @query_service.records_without_pagination
          render :csv => @model.model_name.human
        end
        format.pdf do
          @records = @query_service.records_without_pagination
          @thead_renderer = Carnival::TheadRenderer.new @presenter.fields_for_action(:index), @query_form.sort_column, @query_form.sort_direction
          render :pdf => t("activerecord.attributes.#{@presenter.full_model_name}.pdf_name") , :template => 'carnival/base_admin/index.pdf.haml',  :show_as_html => params[:debug].present? and return
        end
      end
    end

    def show
      show! do
        instantiate_model
      end
    end

    def new
      new! do
        instantiate_model
      end
    end

    def edit
      edit! do
        instantiate_model
      end
    end

    def create
      create! do |success, failure|
        success.html { redirect_to @presenter.model_path(:index), :notice => I18n.t("messages.created") }
        failure.html { instantiate_model and render 'new' }
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to @presenter.model_path(:index), :notice => I18n.t("messages.updated") }
        failure.html { instantiate_model and render 'edit' }
      end
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

    protected

    def instantiate_model
      @model = instance_variable_get("@#{resource_instance_name}")
    end

    def instantiate_presenter
      @presenter = carnival_presenter_class.new controller: self
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
      module_class_split = self.class.to_s.split("::")
      if module_class_split.size > 1
        module_class_split[0]
      else
        ''
      end
    end
  end
end
