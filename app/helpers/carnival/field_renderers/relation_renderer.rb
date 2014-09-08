module Carnival::FieldRenderers
  class RelationRenderer < FieldRenderer
    def render_field(model)
      field = @presenter.get_field(@field_name)
      related_column_name = field.relation_column

      related_presenter_name = @presenter.get_related_class(@field_name)
      related_presenter_name.gsub!(/.*[(::)\/]/, '')
      related_presenter = @presenter.presenter_to_field_sym(related_presenter_name)

      related_model = model.send(@field_name)
      { field_type: related_presenter.field_type(related_column_name), value: related_model.try(related_column_name) }
    end
  end
end
