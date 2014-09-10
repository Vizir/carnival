module Carnival::FieldRenderers
  class RendererCreator
    def self.create_field_renderer(presenter, field_name)
      renderer = if presenter.relation_field? field_name
                   if presenter.is_relation_has_many?(field_name)
                     ManyRelationRenderer
                   else
                     SingleRelationRenderer
                   end
                 else
                   FieldRenderer
                 end
      renderer.new(presenter, field_name)
    end
  end
end
