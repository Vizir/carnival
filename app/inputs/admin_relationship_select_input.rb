class AdminRelationshipSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    super
    @builder.collection_select(
      "#{@builder.object.class.name.constantize.reflections[attribute_name.to_sym].foreign_key}",
      @builder.object.class.name.constantize.reflect_on_association(attribute_name.to_sym).klass.name.constantize.list_for_select,
      :first, :last,
      prompt: I18n.t("#{@builder.object.class.to_s.gsub(/^.*::/, '').downcase}.lista_#{attribute_name}.selecione",
                default: I18n.t("messages.select")),
      input_html: {:class=> 'chosen'}
    )
  end
end
