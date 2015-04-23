module Carnival
  class BatchAction < Action
    include Rails.application.routes.url_helpers

    def initialize(presenter, name, params={})
      @presenter = presenter
      @name = name
      @params = params
      @path = params[:path] if params[:path].present?
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
