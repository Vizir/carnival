class AdminRelationshipSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options)
    super
    input_html_options[:class] << ' carnival-select'
    if input_html_options[:data][:depends_on].nil?
      collection = @builder.object.class.name.constantize.reflect_on_association(attribute_name.to_sym).klass.name.constantize.list_for_select
    else
      depends_on =  @builder.object.class.name.constantize.reflect_on_association(input_html_options[:data][:depends_on]).foreign_key
      depends_on_value = @builder.object.send(depends_on.to_s)
      if depends_on_value.present?
        collection = @builder.object.class.name.constantize.reflect_on_association(attribute_name.to_sym).klass.name.constantize.list_for_select(add_empty_option: true, query: ["#{depends_on} = ?", depends_on_value])
      else
        collection = []
      end
    end

    @builder.collection_select(
      "#{HashWithIndifferentAccess.new(@builder.object.class.name.constantize.reflections)[attribute_name.to_sym].foreign_key}",
      collection,
      :first, :last,
      {prompt: I18n.t("#{@builder.object.class.to_s.gsub(/^.*::/, '').downcase}.lista_#{attribute_name}.selecione", default: I18n.t("messages.select"))},
      input_html_options
    )
  end
end
