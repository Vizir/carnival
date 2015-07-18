module Carnival::FieldRenderers
  class SingleRelationRenderer < FieldRenderer
    def render_field(model)
      related_model = model.send(field.association_name)

      {
        field_type: related_presenter.field_type(field.association_field_name),
        value: related_model.try(field.association_field_name)
      }
    end
  end
end
