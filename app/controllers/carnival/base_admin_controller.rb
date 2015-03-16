module Carnival
  class BaseAdminController < InheritedResources::Base
    respond_to :html, :json
    layout 'carnival/admin'
    before_action :instantiate_presenter
    helper_method :back_or_model_path

    def index
      @query_form = QueryFormCreator.create(@presenter, params)
      @model = @presenter.model_class
      @query_service = QueryService.new(table_items, @presenter, @query_form)
      @thead_renderer = TheadRenderer.new @presenter.fields_for_action(:index), @query_form.sort_column, @query_form.sort_direction

      respond_to do |format|
        format.html do
          @records = @query_service.get_query
          @paginator = Paginator.new @query_form.page, @query_service.page_count
        end
        format.csv do
          @records = @query_service.records_without_pagination
          render csv: @model.model_name.human
        end
        format.pdf do
          @records = @query_service.records_without_pagination
          render pdf: t("activerecord.attributes.#{@presenter.full_model_name}.pdf_name"), template: 'carnival/base_admin/index.pdf.haml',  show_as_html: params[:debug].present?
        end
      end
    end

    [:show, :new, :edit].each do |action|
      define_method action do
        send("#{action}!") do
          instantiate_model
        end
      end
    end

    def create
      create! do |success, failure|
        success.html { redirect_to back_or_model_path, notice: I18n.t('messages.created') }
        failure.html { instantiate_model && render('new') }
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to back_or_model_path, notice: I18n.t('messages.updated') }
        failure.html { instantiate_model && render('edit') }
      end
    end

    def render_inner_form
      @presenter = presenter_name(params[:field]).new controller: self
      model_class = params[:field].classify.constantize
      @model_object = model_class.find(params[:id])
    end

    def load_dependent_select_options
      presenter = params[:presenter].constantize.send(:new, controller: self)
      model = presenter.relation_model(params[:field].gsub('_id', '').to_sym)
      @options = model.list_for_select(add_empty_option: true, query: ["#{params[:dependency_field]} = ?", params[:dependency_value]])
      render layout: nil
    end

    def load_select_options
      model_name = params[:model_name]
      search_field = params[:search_field]
      presenter = params[:presenter_name].constantize.send(:new, controller: self)
      model = presenter.relation_model(model_name.to_sym)
      list = []
      model.where("#{search_field} like '%#{params[:q]}%'").each do |elem|
        list << { id: elem.id, text: elem.send(search_field.to_sym) }
      end

      render json: list
    end

    protected

    def presenter_name(field)
      field_name =  field.split('/').last
      carnival_mount = Carnival::Config.mount_at
      "#{carnival_mount}/#{field_name.singularize}_presenter".classify.constantize
    end

    def table_items
      @presenter.model_class
    end

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
      module_class_split = self.class.to_s.split('::')
      if module_class_split.size > 1
        module_class_split[0]
      else
        ''
      end
    end

    def back_or_model_path
      params[:HTTP_REFERER] || @presenter.model_path(:index)
    end
  end
end
