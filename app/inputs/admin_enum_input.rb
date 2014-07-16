class AdminEnumInput < SimpleForm::Inputs::CollectionSelectInput
  def input
    super
    input_html_options[:class] << ' chosen'

    @builder.collection_select(
      attribute_name, @builder.object.class.const_get(attribute_name.to_s.upcase),
      :first, :last,
      {prompt: I18n.t("#{@builder.object.class.to_s.gsub(/^.*::/, '').downcase}.lista_#{attribute_name}.selecione",
                default: I18n.t("messages.select"))},
      input_html_options
    )
  end
end

