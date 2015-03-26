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

      { field_type: :relation, value: translate_field(full_model_name) }
    end

    protected

    def translate_field(model_class_name)
      i18n_singular_key = "activerecord.models.#{model_class_name.classify.constantize.model_name.i18n_key}"
      i18n_plural_key = "#{i18n_singular_key}_plural"
      if I18n.exists?(i18n_plural_key)
        value = I18n.t(i18n_plural_key)
      else
        value = I18n.t(i18n_singular_key).pluralize
      end
    end
  end
end
