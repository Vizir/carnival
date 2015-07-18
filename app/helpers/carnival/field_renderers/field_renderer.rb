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
      @presenter.related_presenter(field)
    end

    def field
      @presenter.get_field(@field_name)
    end
  end
end
