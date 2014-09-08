module Carnival::FieldRenderers
  class OwnerRelationRenderer < FieldRenderer
    def render_field(model)
      field = @presenter.get_field(@field_name)
      owner_relation = field.owner_relation

      related_presenter = @presenter.presenter_to_field_sym(owner_relation)

      related_model = model.send(owner_relation)
      { field_type: related_presenter.field_type(@field_name), value: related_model.try(@field_name) }
    end
  end
end
