module Carnival::FieldRenderers
  class RendererCreator
    def self.create_field_renderer(presenter, field_name)
      field_type = presenter.field_type(field_name)
      renderer = if presenter.has_owner_relation? field_name
        OwnerRelationRenderer
      elsif field_type == :relation
        RelationRenderer
      else
        FieldRenderer
      end
      renderer.new(presenter, field_name)
    end
  end
end
