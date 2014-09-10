module Carnival::FieldRenderers
  class SingleRelationRenderer < FieldRenderer
    def render_field(model)
      field = @presenter.get_field(@field_name)

      related_presenter_name = @presenter.get_related_class(field.association_name)
      related_presenter_name.gsub!(/.*[(::)\/]/, '')
      related_presenter = @presenter.presenter_to_field_sym(related_presenter_name)

      related_model = model.send(field.association_name)
      { field_type: related_presenter.field_type(field.association_field_name),
        value: related_model.try(field.association_field_name) }
    end
  end
end
