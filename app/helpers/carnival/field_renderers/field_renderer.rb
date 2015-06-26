module Carnival::FieldRenderers
  class FieldRenderer
    def initialize(presenter, field_name)
      @presenter = presenter
      @field_name = field_name
    end

    def render_field(model)
      { field_type: @presenter.field_type(@field_name), value: model.send(@field_name) }
    end

    protected

    def related_presenter
      if field.presenter_class.present?
        field.presenter_class.constantize.new
      else
        infer_presenter
      end
    end

    def infer_presenter
      related_presenter_name =
        @presenter.get_related_class(field.association_name)
        .gsub(/.*[(::)\/]/, '')
      @presenter.presenter_to_field_sym(related_presenter_name)
    end

    def field
      @presenter.get_field(@field_name)
    end
  end
end
