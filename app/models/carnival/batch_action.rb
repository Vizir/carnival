module Carnival
  class BatchAction
    include Rails.application.routes.url_helpers

    def initialize(presenter, name, params={})
      @presenter = presenter
      @name = name
      @params = params
      @path = params[:path] if params[:path].present?
    end

    def path(extra_params={})
      if @path.nil?
        params = {controller: @presenter.controller_name, action: @name}
      else
        params = {path: @path}
      end
      params = params.merge(extra_params) if extra_params.present?
      params = params.merge(:only_path => true)
      url_for(params)
    end

    def params
      @params
    end

    def name
      @name
    end

    def to_label
      I18n.t("#{@presenter.model_name}.#{name}") 
    end

  end
end
