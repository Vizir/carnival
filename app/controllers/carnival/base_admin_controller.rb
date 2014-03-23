module Carnival
  class BaseAdminController < InheritedResources::Base
    respond_to :html, :json
    before_filter :authenticate_admin_user!

    def generate_datatable
      modelo_presenter = "Carnival::#{controller_name.classify}Presenter".constantize.send(:new, :controller => self)
      Carnival::GenericDatatable.new(view_context, "Carnival::#{controller_name.classify}".constantize, self, modelo_presenter)
    end

    def index
      @datatable = generate_datatable
      @advanced_search = params["advanced_search"] if params["advanced_search"].present?

      if params[:special_scope].present?
        presenter = @datatable.presenter
        presenter.parse_special_scope params[:special_scope]
      end

      respond_to do |format|
        format.html do |render|
          render '/carnival/index'
        end
        format.json do |render|
          render(json: @datatable)
        end
        format.csv do
          render text: @datatable.as_csv.encode("utf-16le")
        end
        format.pdf do
          render :pdf => t("#{@datatable.model.to_s.underscore}.lista") , :template => 'carnival/index.pdf.haml',  :show_as_html => params[:debug].present?
        end
      end
    end

    def show
      @model_presenter = "Carnival::#{controller_name.classify}Presenter".constantize.send(:new, :controller => self)
      show! do |format|
        format.html{render '/carnival/shared/form/show'}
      end
    end

    def new
      @model_presenter = "Carnival::#{controller_name.classify}Presenter".constantize.send(:new, :controller => self)
      new! do |format|
        @model = instance_variable_get("@#{controller_name.classify.underscore}")
        format.html{render '/carnival/shared/form/new'}
      end
    end

    def edit
      @model_presenter = "Carnival::#{controller_name.classify}Presenter".constantize.send(:new, :controller => self.class)
      edit! do |format|
        @model = instance_variable_get("@#{controller_name.classify.underscore}")
        format.html{render '/carnival/shared/form/edit'}
      end
    end

    def create
      create!(:notice => I18n.t("messages.created"))
    end

    def update
      update!(:notice => I18n.t("messages.updated"))
    end

    def render_popup partial
      @application_popup = partial
      render 'layouts/shared/render_popup' and return
    end

    def current_user
      current_admin_user
    end
  end
end
