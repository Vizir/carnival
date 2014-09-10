module Carnival::FieldRenderers
  class ManyRelationRenderer < FieldRenderer
    def render_field(model)
      field = @presenter.get_field(@field_name)

      related_presenter_name =
        @presenter.get_related_class(field.association_name)
      related_presenter_name.gsub!(/.*[(::)\/]/, '')
      related_presenter =
        @presenter.presenter_to_field_sym(related_presenter_name)
      full_model_name = related_presenter.full_model_name

      value = I18n.t("activerecord.models.#{full_model_name}").pluralize
      { field_type: :relation, value: value }
    end
  end
end
